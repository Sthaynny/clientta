import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/client_care/domain/client_phone_key.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';
import 'package:clientta/features/clients/domain/models/client_profile.dart';

String clientProfileKey({
  required String clientPhone,
  required String clientName,
}) {
  final phoneKey = normalizeClientPhone(clientPhone);
  if (phoneKey.isNotEmpty) return phoneKey;
  return clientName.trim().toLowerCase();
}

List<ClientProfile> buildClientProfiles({
  required List<ServiceAppointment> appointments,
  required List<EncounterNote> encounterNotes,
  DateTime? now,
}) {
  final reference = now ?? DateTime.now();
  final today = DateTime(reference.year, reference.month, reference.day);
  final buckets = <String, _ClientBucket>{};

  void ensureBucket(String key) {
    buckets.putIfAbsent(key, _ClientBucket.new);
  }

  for (final appointment in appointments) {
    final key = clientProfileKey(
      clientPhone: appointment.clientPhone,
      clientName: appointment.clientName,
    );
    ensureBucket(key);
    final bucket = buckets[key]!;
    bucket.clientName = appointment.clientName;
    bucket.clientPhone = appointment.clientPhone;
    bucket.appointmentCount++;
    bucket._touchActivity(appointment.appointmentDate);
    bucket._touchServiceType(
      appointment.serviceType,
      appointment.appointmentDate,
    );

    final status = AppointmentStatus.fromValue(appointment.status);
    if (status == AppointmentStatus.agendado) {
      final appointmentDay = DateTime(
        appointment.appointmentDate.year,
        appointment.appointmentDate.month,
        appointment.appointmentDate.day,
      );
      if (!appointmentDay.isBefore(today)) {
        bucket._considerNextAppointment(
          appointment.appointmentDate,
          appointment.startTime,
        );
      }
    }
  }

  for (final note in encounterNotes) {
    final key = clientProfileKey(
      clientPhone: note.clientPhone,
      clientName: note.clientName,
    );
    ensureBucket(key);
    final bucket = buckets[key]!;
    bucket.clientName = note.clientName;
    bucket.clientPhone = note.clientPhone;
    bucket.encounterCount++;
    bucket._touchActivity(note.createdAt);
    if (note.serviceType != null && note.serviceType!.trim().isNotEmpty) {
      bucket._touchServiceType(note.serviceType!, note.createdAt);
    }
  }

  final profiles =
      buckets.entries
          .map(
            (entry) => ClientProfile(
              clientKey: entry.key,
              clientName: entry.value.clientName,
              clientPhone: entry.value.clientPhone,
              serviceType: entry.value.serviceType,
              appointmentCount: entry.value.appointmentCount,
              encounterCount: entry.value.encounterCount,
              lastActivityAt: entry.value.lastActivityAt,
              nextAppointmentDate: entry.value.nextAppointmentDate,
              nextAppointmentStartTime: entry.value.nextAppointmentStartTime,
            ),
          )
          .toList();

  profiles.sort((a, b) {
    final aDate = a.lastActivityAt;
    final bDate = b.lastActivityAt;
    if (aDate == null && bDate == null) {
      return a.clientName.toLowerCase().compareTo(b.clientName.toLowerCase());
    }
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    final compare = bDate.compareTo(aDate);
    if (compare != 0) return compare;
    return a.clientName.toLowerCase().compareTo(b.clientName.toLowerCase());
  });

  return profiles;
}

List<ClientProfile> filterClientProfiles(
  List<ClientProfile> profiles,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return profiles;

  final digits = normalizeClientPhone(query);
  return profiles.where((profile) {
    if (profile.clientName.toLowerCase().contains(normalized)) return true;
    if (digits.isNotEmpty &&
        normalizeClientPhone(profile.clientPhone).contains(digits)) {
      return true;
    }
    return profile.clientPhone.toLowerCase().contains(normalized);
  }).toList();
}

class _ClientBucket {
  String clientName = '';
  String clientPhone = '';
  String? serviceType;
  int appointmentCount = 0;
  int encounterCount = 0;
  DateTime? lastActivityAt;
  DateTime? nextAppointmentDate;
  String? nextAppointmentStartTime;
  DateTime? _serviceTypeAt;

  void _touchActivity(DateTime date) {
    if (lastActivityAt == null || date.isAfter(lastActivityAt!)) {
      lastActivityAt = date;
    }
  }

  void _touchServiceType(String type, DateTime at) {
    if (_serviceTypeAt == null || !at.isBefore(_serviceTypeAt!)) {
      serviceType = type;
      _serviceTypeAt = at;
    }
  }

  void _considerNextAppointment(DateTime date, String startTime) {
    if (nextAppointmentDate == null || date.isBefore(nextAppointmentDate!)) {
      nextAppointmentDate = date;
      nextAppointmentStartTime = startTime;
      return;
    }
    final sameDay =
        date.year == nextAppointmentDate!.year &&
        date.month == nextAppointmentDate!.month &&
        date.day == nextAppointmentDate!.day;
    if (sameDay && startTime.compareTo(nextAppointmentStartTime ?? '') < 0) {
      nextAppointmentStartTime = startTime;
    }
  }
}
