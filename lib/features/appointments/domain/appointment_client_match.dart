import 'package:clientta/core/utils/input_masks.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/client_care/domain/client_phone_key.dart';

String appointmentDateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

bool isSameAppointmentDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool phonesMatch(String a, String b) {
  final left = normalizeClientPhone(a);
  final right = normalizeClientPhone(b);
  return left.isNotEmpty && left == right;
}

/// Identificador estável por cliente + data + horário — evita duplicatas no save.
String buildAppointmentSlotId({
  required String clientPhone,
  required DateTime appointmentDate,
  required String startTime,
}) {
  final phone = normalizeClientPhone(clientPhone);
  final date = appointmentDateKey(appointmentDate);
  final time = startTime.trim().replaceAll(':', '');
  return 'slot_${phone}_${date}_$time';
}

ServiceAppointment? findAppointmentAtSlot({
  required List<ServiceAppointment> appointments,
  required String clientPhone,
  required DateTime appointmentDate,
  required String startTime,
  String? excludeId,
}) {
  for (final appointment in appointments) {
    if (excludeId != null && appointment.id == excludeId) continue;
    if (!phonesMatch(appointment.clientPhone, clientPhone)) continue;
    if (!isSameAppointmentDay(appointment.appointmentDate, appointmentDate)) {
      continue;
    }
    if (appointment.startTime.trim() != startTime.trim()) continue;
    return appointment;
  }
  return null;
}

/// Retorna o nome mais recente cadastrado para o telefone informado.
String? findClientNameByPhone({
  required List<ServiceAppointment> appointments,
  required String clientPhone,
}) {
  final phoneKey = normalizeClientPhone(clientPhone);
  if (phoneKey.isEmpty) return null;

  ServiceAppointment? latest;
  for (final appointment in appointments) {
    if (!phonesMatch(appointment.clientPhone, clientPhone)) continue;
    if (latest == null ||
        appointment.appointmentDate.isAfter(latest.appointmentDate)) {
      latest = appointment;
    }
  }
  return latest?.clientName.trim().isEmpty == true ? null : latest?.clientName;
}

String formatStoredClientPhone(String phone) =>
    formatBrPhone(extractDigits(phone.trim()));
