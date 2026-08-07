import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';

class QuickNotesInput {
  const QuickNotesInput({required this.appointment, required this.notes});

  final ServiceAppointment appointment;
  final String notes;
}

class HomeViewModel {
  HomeViewModel({required AppointmentRepository appointmentRepository})
    : _appointmentRepository = appointmentRepository {
    load = CommandBase(_load);
    markComplete = CommandAction<void, ServiceAppointment>(_markComplete);
    updateNotes = CommandAction<void, QuickNotesInput>(_updateNotes);
  }

  final AppointmentRepository _appointmentRepository;

  late final CommandBase<void> load;
  late final CommandAction<void, ServiceAppointment> markComplete;
  late final CommandAction<void, QuickNotesInput> updateNotes;

  List<ServiceAppointment> todayAppointments = [];

  Future<Result<void>> _load() async {
    try {
      final now = DateTime.now();
      final appointments = await _appointmentRepository.getAll();
      todayAppointments =
          appointments
              .where(
                (a) =>
                    a.appointmentDate.year == now.year &&
                    a.appointmentDate.month == now.month &&
                    a.appointmentDate.day == now.day,
              )
              .toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime));

      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _markComplete(ServiceAppointment entry) async {
    try {
      final updated = entry.copyWith(
        status: AppointmentStatus.concluido.value,
      );
      await _appointmentRepository.save(updated);
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _updateNotes(QuickNotesInput input) async {
    try {
      final trimmed = input.notes.trim();
      final updated = input.appointment.copyWith(
        notes: trimmed.isEmpty ? null : trimmed,
        clearNotes: trimmed.isEmpty,
      );
      await _appointmentRepository.save(updated);
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
