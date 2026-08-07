import 'package:clientta/features/client_care/domain/models/care_timeline_entry.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';

List<CareTimelineEntry> buildCareTimeline({
  required List<EncounterNote> encounterNotes,
}) {
  final entries = encounterNotes
      .map(
        (note) => CareTimelineEntry(
          id: note.id,
          body: note.body,
          createdAt: note.createdAt,
          source: CareTimelineSource.encounter,
          serviceType: note.serviceType,
        ),
      )
      .toList();

  entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return entries;
}
