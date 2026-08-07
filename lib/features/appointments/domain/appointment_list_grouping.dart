import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';

class AppointmentListGroup {
  const AppointmentListGroup({
    required this.id,
    required this.title,
    this.subtitle,
    required this.entries,
    required this.sortDate,
  });

  final String id;
  final String title;
  final String? subtitle;
  final List<ServiceAppointment> entries;
  final DateTime sortDate;
}

List<AppointmentListGroup> groupAppointments(List<ServiceAppointment> entries) {
  if (entries.isEmpty) return [];

  final sorted = List<ServiceAppointment>.from(entries)
    ..sort((a, b) {
      final date = b.appointmentDate.compareTo(a.appointmentDate);
      if (date != 0) return date;
      return b.startTime.compareTo(a.startTime);
    });

  final seriesBuckets = <String, List<ServiceAppointment>>{};
  final dateBuckets = <String, List<ServiceAppointment>>{};

  for (final entry in sorted) {
    final seriesId = entry.seriesId;
    if (seriesId != null && seriesId.isNotEmpty) {
      seriesBuckets.putIfAbsent(seriesId, () => []).add(entry);
    } else {
      final key = _dateKey(entry.appointmentDate);
      dateBuckets.putIfAbsent(key, () => []).add(entry);
    }
  }

  final groups = <AppointmentListGroup>[];

  for (final bucket in seriesBuckets.entries) {
    final items = bucket.value
      ..sort((a, b) {
        final date = b.appointmentDate.compareTo(a.appointmentDate);
        if (date != 0) return date;
        return b.startTime.compareTo(a.startTime);
      });
    final first = items.first;
    groups.add(
      AppointmentListGroup(
        id: 'series:${bucket.key}',
        title: recurringSeriesGroupTitleString,
        subtitle: recurringSeriesGroupSubtitle(
          clientName: first.clientName,
          serviceType: first.serviceType,
        ),
        entries: items,
        sortDate: items.first.appointmentDate,
      ),
    );
  }

  for (final bucket in dateBuckets.entries) {
    final items = bucket.value
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
    final date = items.first.appointmentDate;
    groups.add(
      AppointmentListGroup(
        id: 'date:${bucket.key}',
        title: formatHubDayHeader(date),
        subtitle: weekdayLabels[date.weekday - 1],
        entries: items,
        sortDate: date,
      ),
    );
  }

  groups.sort((a, b) => b.sortDate.compareTo(a.sortDate));
  return groups;
}

String _dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
