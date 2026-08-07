import 'package:clientta/features/client_care/domain/models/encounter_note.dart';

abstract class EncounterNoteRepository {
  Future<List<EncounterNote>> getAll();

  Future<List<EncounterNote>> getByClientPhone(String clientPhone);

  Future<void> save(EncounterNote note);

  Future<void> saveAll(
    List<EncounterNote> notes, {
    List<String> deleteIds = const [],
  });

  Future<void> delete(String id);
}
