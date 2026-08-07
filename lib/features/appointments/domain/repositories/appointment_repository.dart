import 'package:clientta/features/appointments/domain/models/service_appointment.dart';

abstract class AppointmentRepository {
  Future<List<ServiceAppointment>> getAll();

  Future<void> save(ServiceAppointment entry);

  Future<void> saveAll(
    List<ServiceAppointment> entries, {
    List<String> deleteIds = const [],
  });

  Future<void> delete(String id);
}
