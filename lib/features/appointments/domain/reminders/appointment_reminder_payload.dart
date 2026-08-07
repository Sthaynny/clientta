import 'dart:convert';

import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/client_care/domain/models/client_care_args.dart';

/// Payload serializado na notificação local para deep link.
abstract final class AppointmentReminderPayload {
  static String encode(ServiceAppointment appointment) {
    return jsonEncode({
      'appointmentId': appointment.id,
      'clientName': appointment.clientName,
      'clientPhone': appointment.clientPhone,
      'serviceType': appointment.serviceType,
    });
  }

  static ClientCareArgs? decodeCareArgs(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final clientName = map['clientName'] as String? ?? '';
      final clientPhone = map['clientPhone'] as String? ?? '';
      if (clientName.isEmpty || clientPhone.isEmpty) return null;
      return ClientCareArgs(
        clientName: clientName,
        clientPhone: clientPhone,
        serviceType: map['serviceType'] as String?,
        appointmentId: map['appointmentId'] as String?,
      );
    } catch (_) {
      return null;
    }
  }
}
