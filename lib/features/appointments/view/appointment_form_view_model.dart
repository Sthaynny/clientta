import 'package:clientta/core/plan/plan_access_policy.dart';
import 'package:clientta/core/storage/app_profile_repository.dart';
import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/data/appointment_reminder_coordinator.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/appointments/data/service_type_catalog_local.dart';
import 'package:clientta/features/client_care/domain/client_phone_key.dart';
import 'package:clientta/features/appointments/domain/appointment_client_match.dart';
import 'package:clientta/features/appointments/domain/appointment_form_validation.dart';
import 'package:clientta/features/appointments/domain/appointment_series_generator.dart';
import 'package:clientta/features/appointments/domain/client_identity_propagation.dart';
import 'package:clientta/features/client_care/domain/client_identity_propagation.dart';
import 'package:clientta/features/client_care/domain/repositories/encounter_note_repository.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/service_type_catalog.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_settings.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/auth/domain/repositories/user_repository.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';

enum SeriesEditScope { single, entireSeries }

enum ClientPhoneMatchChoice { mergeExisting, createNew }

class AppointmentFormViewModel {
  AppointmentFormViewModel({
    required AppointmentRepository repository,
    required BillingRepository billingRepository,
    required ServiceTypeCatalogLocal serviceTypeCatalog,
    UserRepository? userRepository,
    ServiceAppointment? initial,
    String? prefillClientName,
    String? prefillClientPhone,
    String? prefillServiceType,
    bool lockClientFields = false,
    AppointmentSyncService? syncService,
    AppointmentReminderCoordinator? reminderCoordinator,
    AppProfileRepository? appProfileRepository,
    EncounterNoteRepository? encounterRepository,
  }) : _repository = repository,
       _billingRepository = billingRepository,
       _serviceTypeCatalog = serviceTypeCatalog,
       _userRepository = userRepository,
       _initial = initial,
       _prefillClientName = prefillClientName,
       _prefillClientPhone = prefillClientPhone,
       _prefillServiceType = prefillServiceType,
       _lockClientFields = lockClientFields,
       _syncService = syncService,
       _reminderCoordinator = reminderCoordinator,
       _appProfileRepository = appProfileRepository,
       _encounterRepository = encounterRepository {
    save = CommandBase(_save);
  }

  final AppointmentRepository _repository;
  final BillingRepository _billingRepository;
  final ServiceTypeCatalogLocal _serviceTypeCatalog;
  final UserRepository? _userRepository;
  final ServiceAppointment? _initial;
  final String? _prefillClientName;
  final String? _prefillClientPhone;
  final String? _prefillServiceType;
  final bool _lockClientFields;
  final AppointmentSyncService? _syncService;
  final AppointmentReminderCoordinator? _reminderCoordinator;
  final AppProfileRepository? _appProfileRepository;
  final EncounterNoteRepository? _encounterRepository;

  late final CommandBase<void> save;

  bool hasProReminders = false;
  bool remindersEnabled = true;
  int reminderLeadMinutes = AppointmentReminderSettings.defaultLeadMinutes;

  String clientName = '';
  String clientPhone = '';
  String serviceType = '';
  DateTime appointmentDate = DateTime.now();
  String startTime = '09:00';
  String endTime = '10:00';
  String status = AppointmentStatus.agendado.value;
  String notes = '';
  Set<int> selectedWeekdays = {};
  SeriesEditScope? pendingSeriesEditScope;
  AppointmentFormFieldErrors fieldErrors = const AppointmentFormFieldErrors();
  List<String> serviceTypeOptions = [];
  String? _resolvedClientPhoneKey;

  bool get isEdit => _initial != null;
  bool get lockClientFields => _lockClientFields && !isEdit;
  bool get isSeriesEdit =>
      _initial?.seriesId != null && _initial!.seriesId!.isNotEmpty;

  void setStartTime(String value) {
    startTime = value;
    endTime = _defaultEndTimeForStart(value);
  }

  String _defaultEndTimeForStart(String start) {
    final parts = start.split(':');
    if (parts.length < 2) return '10:00';
    final hour = int.tryParse(parts[0]) ?? 9;
    final minute = int.tryParse(parts[1]) ?? 0;
    final totalMinutes = (hour * 60 + minute + 60).clamp(0, 23 * 60 + 59);
    final endHour = totalMinutes ~/ 60;
    final endMinute = totalMinutes % 60;
    return '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
  }

  void _ensureValidEndTime() {
    final startMinutes = _minutesFromHhMm(startTime);
    final endMinutes = _minutesFromHhMm(endTime);
    if (startMinutes == null ||
        endMinutes == null ||
        endMinutes <= startMinutes) {
      endTime = _defaultEndTimeForStart(startTime);
    }
  }

  int? _minutesFromHhMm(String value) {
    final parts = value.trim().split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return hour * 60 + minute;
  }

  void hydrate() {
    final entry = _initial;
    if (entry != null) {
      clientName = entry.clientName;
      clientPhone = entry.clientPhone;
      serviceType = entry.serviceType;
      appointmentDate = entry.appointmentDate;
      startTime = entry.startTime;
      endTime = entry.endTime;
      status = entry.status;
      notes = entry.notes ?? '';
      return;
    }

    final prefillName = _prefillClientName;
    if (prefillName != null) {
      clientName = prefillName;
      clientPhone = _prefillClientPhone ?? '';
      serviceType = _prefillServiceType ?? '';
    }
  }

  void clearFieldError(String field) {
    fieldErrors = AppointmentFormFieldErrors(
      clientName: field == 'clientName' ? null : fieldErrors.clientName,
      clientPhone: field == 'clientPhone' ? null : fieldErrors.clientPhone,
      serviceType: field == 'serviceType' ? null : fieldErrors.serviceType,
      startTime: field == 'startTime' ? null : fieldErrors.startTime,
      endTime: field == 'endTime' ? null : fieldErrors.endTime,
    );
  }

  bool validateFields() {
    _ensureValidEndTime();
    fieldErrors = validateAppointmentFormFields(
      clientName: clientName,
      clientPhone: clientPhone,
      serviceType: serviceType,
      startTime: startTime,
      endTime: endTime,
    );
    return !fieldErrors.hasErrors;
  }

  List<ServiceAppointment> _knownAppointments = [];

  ExistingClientMatch? existingClientMatchForPhone(String phone) {
    if (isEdit || lockClientFields) return null;
    return findExistingClientMatch(
      appointments: _knownAppointments,
      clientPhone: phone,
    );
  }

  bool hasResolvedClientPhone(String phone) {
    final key = normalizeClientPhone(phone);
    return key.isNotEmpty && key == _resolvedClientPhoneKey;
  }

  void applyClientPhoneMatchChoice({
    required ClientPhoneMatchChoice choice,
    required ExistingClientMatch match,
  }) {
    _resolvedClientPhoneKey = match.phoneKey;
    if (choice == ClientPhoneMatchChoice.mergeExisting) {
      clientName = match.existingName;
      clearFieldError('clientName');
    }
  }

  void resetClientPhoneResolution() {
    _resolvedClientPhoneKey = null;
  }

  Future<void> refreshKnownAppointments() async {
    _knownAppointments = await _repository.getAll();
    await refreshServiceTypeOptions();
  }

  Future<void> loadReminderPreferences() async {
    final subscription = await _billingRepository.getSubscription();
    hasProReminders = PlanAccessPolicy.canScheduleLocalReminders(subscription);

    final coordinator = _reminderCoordinator;
    if (coordinator != null) {
      final settings = await coordinator.readSettings();
      remindersEnabled = settings.enabled;
      reminderLeadMinutes = settings.leadMinutes;
      return;
    }

    final profileRepo = _appProfileRepository;
    if (profileRepo != null) {
      final settings = (await profileRepo.load()).appointmentReminders;
      remindersEnabled = settings.enabled;
      reminderLeadMinutes = settings.leadMinutes;
    }
  }

  Future<bool> updateRemindersEnabled(bool enabled) async {
    if (!hasProReminders) return false;

    remindersEnabled = enabled;
    final settings = AppointmentReminderSettings(
      enabled: enabled,
      leadMinutes: reminderLeadMinutes,
    );
    final all = await _repository.getAll();
    await _reminderCoordinator?.persistSettingsAndSync(
      settings: settings,
      appointments: all,
    );
    return true;
  }

  Future<void> _syncRemindersAfterSave() async {
    final all = await _repository.getAll();
    await _reminderCoordinator?.syncForAppointments(all);
  }

  Future<void> refreshServiceTypeOptions() async {
    final saved = await _serviceTypeCatalog.readSaved();
    serviceTypeOptions = mergeServiceTypes(
      saved: saved,
      fromAppointments: _knownAppointments.map((entry) => entry.serviceType),
    );
  }

  Future<Result<void>> _save() async {
    if (!validateFields()) {
      return Result.errorDefault(fieldErrors.clientName ?? errorSaveString);
    }

    try {
      final trimmedNotes = notes.trim();
      final notesValue = trimmedNotes.isEmpty ? null : trimmedNotes;

      if (isEdit) {
        return await _saveEdit(notesValue);
      }
      return await _saveCreate(notesValue);
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _saveCreate(String? notesValue) async {
    final subscription = await _billingRepository.getSubscription();
    final existing = await _repository.getAll();
    _knownAppointments = existing;

    final trimmedName = clientName.trim();
    final storedPhone = formatStoredClientPhone(clientPhone);
    final trimmedServiceType = serviceType.trim();

    if (selectedWeekdays.isNotEmpty) {
      if (!PlanAccessPolicy.canCreateSeries(
        subscription: subscription,
        existingAppointments: existing,
      )) {
        return Result.error(
          Exception(
            planFreeLimitSeriesMessage(PlanAccessPolicy.freeMaxActiveSeries),
          ),
        );
      }

      final seriesId = 'series_${DateTime.now().millisecondsSinceEpoch}';
      final seriesEntries = buildRecurringAppointments(
        seriesId: seriesId,
        anchorDate: appointmentDate,
        weekdays: selectedWeekdays,
        clientName: trimmedName,
        clientPhone: storedPhone,
        serviceType: trimmedServiceType,
        startTime: startTime.trim(),
        endTime: endTime.trim(),
        status: status,
        notes: notesValue,
      );

      if (seriesEntries.isEmpty) {
        return Result.errorDefault(errorSaveString);
      }

      if (!PlanAccessPolicy.canAddAppointment(
        subscription: subscription,
        existingAppointments: existing,
        additionalCount: seriesEntries.length,
      )) {
        return Result.error(
          Exception(
            planFreeLimitAppointmentsMessage(
              PlanAccessPolicy.freeMaxActiveAppointments,
            ),
          ),
        );
      }

      await _repository.saveAll(seriesEntries);
      await _serviceTypeCatalog.addIfNew(trimmedServiceType);
      _syncService?.scheduleSync();
      await _userRepository?.touchLastActivity();
      await _syncRemindersAfterSave();
      return Result.ok();
    }

    if (!PlanAccessPolicy.canAddAppointment(
      subscription: subscription,
      existingAppointments: existing,
    )) {
      return Result.error(
        Exception(
          planFreeLimitAppointmentsMessage(
            PlanAccessPolicy.freeMaxActiveAppointments,
          ),
        ),
      );
    }

    final entry = buildSingleAppointment(
      id: buildAppointmentSlotId(
        clientPhone: storedPhone,
        appointmentDate: appointmentDate,
        startTime: startTime.trim(),
      ),
      clientName: trimmedName,
      clientPhone: storedPhone,
      serviceType: trimmedServiceType,
      appointmentDate: appointmentDate,
      startTime: startTime.trim(),
      endTime: endTime.trim(),
      status: status,
      notes: notesValue,
    );
    await _repository.save(entry);
    await _serviceTypeCatalog.addIfNew(trimmedServiceType);
    _syncService?.scheduleSync();
    await _userRepository?.touchLastActivity();
    await _syncRemindersAfterSave();
    return Result.ok();
  }

  Future<Result<void>> _saveEdit(String? notesValue) async {
    final initial = _initial!;
    final trimmedName = clientName.trim();
    final storedPhone = formatStoredClientPhone(clientPhone);
    final trimmedServiceType = serviceType.trim();
    final updated = buildSingleAppointment(
      id: initial.id,
      clientName: trimmedName,
      clientPhone: storedPhone,
      serviceType: trimmedServiceType,
      appointmentDate: appointmentDate,
      startTime: startTime.trim(),
      endTime: endTime.trim(),
      status: status,
      notes: notesValue,
      seriesId: initial.seriesId,
    );

    final all = await _repository.getAll();
    final identityChanged = clientIdentityChanged(
      previousPhone: initial.clientPhone,
      newPhone: storedPhone,
      previousName: initial.clientName,
      newName: trimmedName,
    );

    List<ServiceAppointment> toSave;

    if (isSeriesEdit &&
        pendingSeriesEditScope == SeriesEditScope.entireSeries) {
      final seriesEntries =
          all.where((entry) => entry.seriesId == initial.seriesId).toList();
      toSave = applySeriesEdit(
        seriesEntries: seriesEntries,
        editedEntry: updated,
        clientName: trimmedName,
        clientPhone: storedPhone,
        serviceType: trimmedServiceType,
        startTime: startTime.trim(),
        endTime: endTime.trim(),
        status: status,
        notes: notesValue,
        entireSeries: true,
      );
    } else {
      toSave = [updated];
    }

    if (identityChanged) {
      final excludeIds = toSave.map((entry) => entry.id).toSet();
      final propagated = propagateClientIdentityToAppointments(
        appointments: all,
        previousPhone: initial.clientPhone,
        newClientName: trimmedName,
        newClientPhone: storedPhone,
        excludeIds: excludeIds,
      );
      toSave = mergeAppointmentsById([...toSave, ...propagated]);
      await _propagateEncounterNotes(
        previousPhone: initial.clientPhone,
        newClientName: trimmedName,
        newClientPhone: storedPhone,
      );
    }

    await _repository.saveAll(toSave);
    await _serviceTypeCatalog.addIfNew(trimmedServiceType);
    _syncService?.scheduleSync();
    await _userRepository?.touchLastActivity();
    await _syncRemindersAfterSave();
    return Result.ok();
  }

  Future<void> _propagateEncounterNotes({
    required String previousPhone,
    required String newClientName,
    required String newClientPhone,
  }) async {
    final encounterRepository = _encounterRepository;
    if (encounterRepository == null) return;

    final notes = await encounterRepository.getAll();
    final updates = propagateClientIdentityToEncounterNotes(
      notes: notes,
      previousPhone: previousPhone,
      newClientName: newClientName,
      newClientPhone: newClientPhone,
    );
    if (updates.isEmpty) return;
    await encounterRepository.saveAll(updates);
  }
}
