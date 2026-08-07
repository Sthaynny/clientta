import 'package:clientta/core/plan/plan_access_policy.dart';
import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/appointments/domain/appointment_form_validation.dart';
import 'package:clientta/features/appointments/domain/appointment_series_generator.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/models/service_type.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/auth/domain/repositories/user_repository.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';

enum SeriesEditScope { single, entireSeries }

class AppointmentFormViewModel {
  AppointmentFormViewModel({
    required AppointmentRepository repository,
    required BillingRepository billingRepository,
    UserRepository? userRepository,
    ServiceAppointment? initial,
    String? prefillClientName,
    String? prefillClientPhone,
    String? prefillServiceType,
    AppointmentSyncService? syncService,
  }) : _repository = repository,
       _billingRepository = billingRepository,
       _userRepository = userRepository,
       _initial = initial,
       _prefillClientName = prefillClientName,
       _prefillClientPhone = prefillClientPhone,
       _prefillServiceType = prefillServiceType,
       _syncService = syncService {
    save = CommandBase(_save);
  }

  final AppointmentRepository _repository;
  final BillingRepository _billingRepository;
  final UserRepository? _userRepository;
  final ServiceAppointment? _initial;
  final String? _prefillClientName;
  final String? _prefillClientPhone;
  final String? _prefillServiceType;
  final AppointmentSyncService? _syncService;

  late final CommandBase<void> save;

  String clientName = '';
  String clientPhone = '';
  String serviceType = ServiceType.emprestimoConsignado;
  DateTime appointmentDate = DateTime.now();
  String startTime = '09:00';
  String endTime = '10:00';
  String status = AppointmentStatus.agendado.value;
  String notes = '';
  Set<int> selectedWeekdays = {};
  SeriesEditScope? pendingSeriesEditScope;
  AppointmentFormFieldErrors fieldErrors = const AppointmentFormFieldErrors();

  bool get isEdit => _initial != null;
  bool get isSeriesEdit =>
      _initial?.seriesId != null && _initial!.seriesId!.isNotEmpty;
  bool get showRecurringOptions => !isEdit;

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
      serviceType = _prefillServiceType ?? ServiceType.emprestimoConsignado;
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
    fieldErrors = validateAppointmentFormFields(
      clientName: clientName,
      clientPhone: clientPhone,
      serviceType: serviceType,
      startTime: startTime,
      endTime: endTime,
    );
    return !fieldErrors.hasErrors;
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

    if (selectedWeekdays.isNotEmpty &&
        !PlanAccessPolicy.canCreateSeries(
          subscription: subscription,
          existingAppointments: existing,
        )) {
      return Result.error(
        Exception(
          planFreeLimitSeriesMessage(PlanAccessPolicy.freeMaxActiveSeries),
        ),
      );
    }

    if (selectedWeekdays.isNotEmpty) {
      final seriesId = DateTime.now().microsecondsSinceEpoch.toString();
      final entries = buildRecurringAppointments(
        seriesId: seriesId,
        anchorDate: appointmentDate,
        weekdays: selectedWeekdays,
        clientName: clientName.trim(),
        clientPhone: clientPhone.trim(),
        serviceType: serviceType,
        startTime: startTime.trim(),
        endTime: endTime.trim(),
        status: status,
        notes: notesValue,
      );
      await _repository.saveAll(entries);
      _syncService?.scheduleSync();
      await _userRepository?.touchLastActivity();
      return Result.ok();
    }

    final entry = buildSingleAppointment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      clientName: clientName.trim(),
      clientPhone: clientPhone.trim(),
      serviceType: serviceType,
      appointmentDate: appointmentDate,
      startTime: startTime.trim(),
      endTime: endTime.trim(),
      status: status,
      notes: notesValue,
    );
    await _repository.save(entry);
    _syncService?.scheduleSync();
    await _userRepository?.touchLastActivity();
    return Result.ok();
  }

  Future<Result<void>> _saveEdit(String? notesValue) async {
    final initial = _initial!;
    final updated = buildSingleAppointment(
      id: initial.id,
      clientName: clientName.trim(),
      clientPhone: clientPhone.trim(),
      serviceType: serviceType,
      appointmentDate: appointmentDate,
      startTime: startTime.trim(),
      endTime: endTime.trim(),
      status: status,
      notes: notesValue,
      seriesId: initial.seriesId,
    );

    if (isSeriesEdit &&
        pendingSeriesEditScope == SeriesEditScope.entireSeries) {
      final all = await _repository.getAll();
      final seriesEntries =
          all.where((entry) => entry.seriesId == initial.seriesId).toList();
      final batch = applySeriesEdit(
        seriesEntries: seriesEntries,
        editedEntry: updated,
        clientName: clientName.trim(),
        clientPhone: clientPhone.trim(),
        serviceType: serviceType,
        startTime: startTime.trim(),
        endTime: endTime.trim(),
        status: status,
        notes: notesValue,
        entireSeries: true,
      );
      await _repository.saveAll(batch);
      _syncService?.scheduleSync();
      await _userRepository?.touchLastActivity();
      return Result.ok();
    }

    await _repository.save(updated);
    _syncService?.scheduleSync();
    await _userRepository?.touchLastActivity();
    return Result.ok();
  }
}
