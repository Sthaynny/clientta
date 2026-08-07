import 'package:clientta/core/plan/plan_access_policy.dart';
import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/appointments/domain/appointment_client_match.dart';
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
    bool lockClientFields = false,
    AppointmentSyncService? syncService,
  }) : _repository = repository,
       _billingRepository = billingRepository,
       _userRepository = userRepository,
       _initial = initial,
       _prefillClientName = prefillClientName,
       _prefillClientPhone = prefillClientPhone,
       _prefillServiceType = prefillServiceType,
       _lockClientFields = lockClientFields,
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
  final bool _lockClientFields;
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
  SeriesEditScope? pendingSeriesEditScope;
  AppointmentFormFieldErrors fieldErrors = const AppointmentFormFieldErrors();

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

  /// Preenche o nome do cliente quando o telefone já existe na agenda.
  String? resolveClientNameFromPhone(String phone) {
    if (clientName.trim().isNotEmpty || isEdit) return null;
    return findClientNameByPhone(
      appointments: _knownAppointments,
      clientPhone: phone,
    );
  }

  Future<void> refreshKnownAppointments() async {
    _knownAppointments = await _repository.getAll();
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
    final storedPhone = formatStoredClientPhone(clientPhone);
    final updated = buildSingleAppointment(
      id: initial.id,
      clientName: clientName.trim(),
      clientPhone: storedPhone,
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
        clientPhone: storedPhone,
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
