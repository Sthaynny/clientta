import 'package:clientta/features/client_care/domain/models/encounter_note.dart';

abstract class EncounterNoteRepositoryRemote {
  Future<List<EncounterNote>> fetchAll(String userId);

  Future<void> upsert(String userId, EncounterNote note);

  Future<void> delete(String userId, String noteId);
}
