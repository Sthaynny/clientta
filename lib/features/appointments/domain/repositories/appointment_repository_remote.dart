import 'package:clientta/features/appointments/domain/models/service_appointment.dart';

abstract class AppointmentRepositoryRemote {
  Future<List<ServiceAppointment>> fetchAll(String userId);

  Future<void> upsert(String userId, ServiceAppointment entry);

  Future<void> delete(String userId, String appointmentId);
}
