import 'package:clientta/features/client_care/domain/models/encounter_note.dart';

bool hasEncounterSessionToday(
  List<EncounterNote> notes, {
  required String sessionBody,
  DateTime? reference,
}) {
  final now = reference ?? DateTime.now();
  return notes.any(
    (note) =>
        note.body == sessionBody && _isSameDay(note.createdAt, now),
  );
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
