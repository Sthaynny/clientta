import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_settings.dart';

abstract final class AppointmentReminderPolicy {
  static int notificationIdFor(String appointmentId) {
    return appointmentId.hashCode & 0x7fffffff;
  }

  static bool isEligible(ServiceAppointment appointment) {
    return AppointmentStatus.fromValue(appointment.status) ==
        AppointmentStatus.agendado;
  }

  /// Horário em que a notificação deve disparar, ou `null` se não aplicável.
  static DateTime? fireAt({
    required ServiceAppointment appointment,
    int leadMinutes = AppointmentReminderSettings.defaultLeadMinutes,
    DateTime? reference,
  }) {
    if (!isEligible(appointment)) return null;

    final start = _appointmentStartAt(appointment);
    if (start == null) return null;

    final fireAt = start.subtract(Duration(minutes: leadMinutes));
    final now = reference ?? DateTime.now();
    if (!fireAt.isAfter(now)) return null;
    return fireAt;
  }

  static DateTime? _appointmentStartAt(ServiceAppointment appointment) {
    final parts = appointment.startTime.trim().split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    final date = appointment.appointmentDate;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
