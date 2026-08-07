import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/client_care/domain/client_phone_key.dart';
import 'package:clientta/features/client_care/domain/models/care_timeline_entry.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';

List<CareTimelineEntry> buildCareTimeline({
  required String clientPhone,
  required List<EncounterNote> encounterNotes,
  required List<ServiceAppointment> appointments,
}) {
  final phoneKey = normalizeClientPhone(clientPhone);
  final linkedAppointmentIds = encounterNotes
      .map((note) => note.appointmentId)
      .whereType<String>()
      .toSet();

  final entries = <CareTimelineEntry>[
    ...encounterNotes.map(
      (note) => CareTimelineEntry(
        id: note.id,
        body: note.body,
        createdAt: note.createdAt,
        source: CareTimelineSource.encounter,
        serviceType: note.serviceType,
      ),
    ),
    ...appointments
        .where(
          (appointment) =>
              normalizeClientPhone(appointment.clientPhone) == phoneKey &&
              appointment.notes != null &&
              appointment.notes!.trim().isNotEmpty &&
              !linkedAppointmentIds.contains(appointment.id),
        )
        .map(
          (appointment) => CareTimelineEntry(
            id: 'appointment-${appointment.id}',
            body: appointment.notes!.trim(),
            createdAt: DateTime(
              appointment.appointmentDate.year,
              appointment.appointmentDate.month,
              appointment.appointmentDate.day,
              _hourFromTime(appointment.startTime),
              _minuteFromTime(appointment.startTime),
            ),
            source: CareTimelineSource.appointment,
            contextLabel:
                '${_formatDate(appointment.appointmentDate)} · ${appointment.startTime}',
            serviceType: appointment.serviceType,
          ),
        ),
  ];

  entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return entries;
}

int _hourFromTime(String time) {
  final parts = time.split(':');
  return int.tryParse(parts.first) ?? 0;
}

int _minuteFromTime(String time) {
  final parts = time.split(':');
  if (parts.length < 2) return 0;
  return int.tryParse(parts[1]) ?? 0;
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
