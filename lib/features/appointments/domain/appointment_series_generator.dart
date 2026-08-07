import 'package:clientta/features/appointments/domain/appointment_client_match.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';

const defaultRecurringWeeks = 4;

List<ServiceAppointment> buildRecurringAppointments({
  required String seriesId,
  required DateTime anchorDate,
  required Set<int> weekdays,
  required String clientName,
  required String clientPhone,
  required String serviceType,
  required String startTime,
  required String endTime,
  required String status,
  String? notes,
  int weeks = defaultRecurringWeeks,
}) {
  if (weekdays.isEmpty) return [];

  final normalizedAnchor = DateTime(
    anchorDate.year,
    anchorDate.month,
    anchorDate.day,
  );
  final entries = <ServiceAppointment>[];
  final seenDates = <String>{};

  for (var week = 0; week < weeks; week++) {
    for (final weekday in weekdays) {
      final date = _dateForWeekday(normalizedAnchor, weekday, week);
      final key = _dateKey(date);
      if (seenDates.contains(key)) continue;
      seenDates.add(key);

      entries.add(
        ServiceAppointment(
          id: buildAppointmentSlotId(
            clientPhone: clientPhone,
            appointmentDate: date,
            startTime: startTime,
          ),
          clientName: clientName,
          clientPhone: clientPhone,
          serviceType: serviceType,
          appointmentDate: date,
          startTime: startTime,
          endTime: endTime,
          status: status,
          notes: notes,
          seriesId: seriesId,
        ),
      );
    }
  }

  entries.sort((a, b) {
    final date = a.appointmentDate.compareTo(b.appointmentDate);
    if (date != 0) return date;
    return a.startTime.compareTo(b.startTime);
  });

  return entries;
}

DateTime _dateForWeekday(DateTime anchor, int weekday, int weekOffset) {
  final startOfWeek = anchor.subtract(Duration(days: anchor.weekday - 1));
  final date = startOfWeek.add(Duration(days: weekday - 1 + (weekOffset * 7)));
  return DateTime(date.year, date.month, date.day);
}

String _dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

ServiceAppointment buildSingleAppointment({
  required String id,
  required String clientName,
  required String clientPhone,
  required String serviceType,
  required DateTime appointmentDate,
  required String startTime,
  required String endTime,
  required String status,
  String? notes,
  String? seriesId,
}) {
  return ServiceAppointment(
    id: id,
    clientName: clientName,
    clientPhone: clientPhone,
    serviceType: serviceType,
    appointmentDate: DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
    ),
    startTime: startTime,
    endTime: endTime,
    status: status,
    notes: notes,
    seriesId: seriesId,
  );
}

List<ServiceAppointment> applySeriesEdit({
  required List<ServiceAppointment> seriesEntries,
  required ServiceAppointment editedEntry,
  required String clientName,
  required String clientPhone,
  required String serviceType,
  required String startTime,
  required String endTime,
  required String status,
  String? notes,
  required bool entireSeries,
}) {
  if (!entireSeries) {
    return [
      editedEntry.copyWith(
        clientName: clientName,
        clientPhone: clientPhone,
        serviceType: serviceType,
        startTime: startTime,
        endTime: endTime,
        status: status,
        notes: notes,
        clearNotes: notes == null,
      ),
    ];
  }

  return seriesEntries
      .map(
        (entry) => entry.copyWith(
          clientName: clientName,
          clientPhone: clientPhone,
          serviceType: serviceType,
          startTime: startTime,
          endTime: endTime,
          status: status,
          notes: notes,
          clearNotes: notes == null,
        ),
      )
      .toList();
}
