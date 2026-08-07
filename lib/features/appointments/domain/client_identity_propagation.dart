import 'package:clientta/features/appointments/domain/appointment_client_match.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';

bool clientIdentityChanged({
  required String previousPhone,
  required String newPhone,
  required String previousName,
  required String newName,
}) {
  return !phonesMatch(previousPhone, newPhone) ||
      previousName.trim() != newName.trim();
}

List<ServiceAppointment> propagateClientIdentityToAppointments({
  required List<ServiceAppointment> appointments,
  required String previousPhone,
  required String newClientName,
  required String newClientPhone,
  Set<String> excludeIds = const {},
}) {
  final trimmedName = newClientName.trim();
  final updates = <ServiceAppointment>[];

  for (final appointment in appointments) {
    if (excludeIds.contains(appointment.id)) continue;
    if (!phonesMatch(appointment.clientPhone, previousPhone)) continue;
    if (appointment.clientName.trim() == trimmedName &&
        phonesMatch(appointment.clientPhone, newClientPhone)) {
      continue;
    }

    updates.add(
      appointment.copyWith(
        clientName: trimmedName,
        clientPhone: newClientPhone,
      ),
    );
  }

  return updates;
}

List<ServiceAppointment> mergeAppointmentsById(
  List<ServiceAppointment> entries,
) {
  final byId = <String, ServiceAppointment>{};
  for (final entry in entries) {
    byId[entry.id] = entry;
  }
  return byId.values.toList();
}
