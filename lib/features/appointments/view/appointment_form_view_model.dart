import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/domain/appointment_form_validation.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/models/service_type.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';

class AppointmentFormViewModel {
  AppointmentFormViewModel({
    required AppointmentRepository repository,
    ServiceAppointment? initial,
  }) : _repository = repository,
       _initial = initial {
    save = CommandBase(_save);
  }

  final AppointmentRepository _repository;
  final ServiceAppointment? _initial;

  late final CommandBase<void> save;

  String clientName = '';
  String clientPhone = '';
  String serviceType = ServiceType.emprestimoConsignado;
  DateTime appointmentDate = DateTime.now();
  String startTime = '09:00';
  String endTime = '10:00';
  String status = AppointmentStatus.agendado.value;
  String notes = '';

  void hydrate() {
    final entry = _initial;
    if (entry == null) return;

    clientName = entry.clientName;
    clientPhone = entry.clientPhone;
    serviceType = entry.serviceType;
    appointmentDate = entry.appointmentDate;
    startTime = entry.startTime;
    endTime = entry.endTime;
    status = entry.status;
    notes = entry.notes ?? '';
  }

  Future<Result<void>> _save() async {
    final validation = validateAppointmentForm(
      clientName: clientName,
      clientPhone: clientPhone,
      serviceType: serviceType,
      startTime: startTime,
      endTime: endTime,
    );
    if (validation.isError) return validation;

    try {
      final trimmedNotes = notes.trim();
      final entry = ServiceAppointment(
        id: _initial?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        clientName: clientName.trim(),
        clientPhone: clientPhone.trim(),
        serviceType: serviceType,
        appointmentDate: DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
        ),
        startTime: startTime.trim(),
        endTime: endTime.trim(),
        status: status,
        notes: trimmedNotes.isEmpty ? null : trimmedNotes,
        seriesId: _initial?.seriesId,
      );

      await _repository.save(entry);
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
