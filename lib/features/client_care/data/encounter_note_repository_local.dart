import 'package:clientta/core/storage/device_json_store.dart';
import 'package:clientta/features/client_care/domain/client_phone_key.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';
import 'package:clientta/features/client_care/domain/repositories/encounter_note_repository.dart';

class EncounterNoteRepositoryLocal implements EncounterNoteRepository {
  EncounterNoteRepositoryLocal(this._store);

  final DeviceJsonStore _store;
  static const _key = 'encounterNotes';

  @override
  Future<List<EncounterNote>> getAll() async {
    final list = await _readEntries();
    return list..sort(_compare);
  }

  @override
  Future<List<EncounterNote>> getByClientPhone(String clientPhone) async {
    final phoneKey = normalizeClientPhone(clientPhone);
    final list = await _readEntries();
    return list
        .where(
          (note) => normalizeClientPhone(note.clientPhone) == phoneKey,
        )
        .toList()
      ..sort(_compare);
  }

  @override
  Future<void> save(EncounterNote note) async {
    final root = await _store.readRoot();
    final list = (root[_key] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    final stamped = note.updatedAt == null
        ? note.copyWith(updatedAt: DateTime.now())
        : note;
    final map = stamped.toMap();
    final index = list.indexWhere((e) => e['id'] == note.id);
    if (index >= 0) {
      list[index] = map;
    } else {
      list.add(map);
    }

    root[_key] = list;
    await _store.writeRoot(root);
  }

  @override
  Future<void> delete(String id) async {
    final root = await _store.readRoot();
    final list = (root[_key] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    list.removeWhere((e) => e['id'] == id);
    root[_key] = list;
    await _store.writeRoot(root);
  }

  Future<List<EncounterNote>> _readEntries() async {
    final root = await _store.readRoot();
    final list = root[_key] as List<dynamic>? ?? [];
    return list
        .map(
          (e) => EncounterNote.fromMap(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  int _compare(EncounterNote a, EncounterNote b) =>
      b.createdAt.compareTo(a.createdAt);
}
