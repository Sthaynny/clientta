import 'package:clientta/features/appointments/domain/models/service_appointment.dart';

/// Contrato para agendar notificações locais de atendimento (implementação OS).
abstract class AppointmentReminderScheduler {
  Future<void> initialize();

  Future<bool> requestPermissionsIfNeeded();

  Future<void> scheduleAppointmentReminder({
    required ServiceAppointment appointment,
    required DateTime fireAt,
    required String title,
    required String body,
    String? payload,
  });

  Future<void> cancelAppointmentReminder(String appointmentId);

  Future<void> cancelAll();
}
