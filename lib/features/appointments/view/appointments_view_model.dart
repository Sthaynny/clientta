import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';

class AppointmentsViewModel {
  AppointmentsViewModel({required AppointmentRepository repository})
    : _repository = repository {
    load = CommandBase(_load);
    deleteEntry = CommandAction<void, String>(_deleteEntry);
  }

  final AppointmentRepository _repository;
  late final CommandBase<void> load;
  late final CommandAction<void, String> deleteEntry;

  List<ServiceAppointment> entries = [];

  Future<Result<void>> _load() async {
    try {
      entries = await _repository.getAll();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _deleteEntry(String id) async {
    try {
      await _repository.delete(id);
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
