import 'package:ufersa_hub/core/storage/device_json_store.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/classes/domain/repositories/class_repository.dart';

class ClassRepositoryLocal implements ClassRepository {
  ClassRepositoryLocal(this._store);

  final DeviceJsonStore _store;
  static const _key = 'classes';

  @override
  Future<List<ClassEntry>> getAll() async {
    final list = await _readEntries();
    return list..sort(_compare);
  }

  @override
  Future<List<ClassEntry>> getBySeriesId(String seriesId) async {
    final all = await _readEntries();
    return all.where((e) => e.seriesId == seriesId).toList()..sort(_compare);
  }

  @override
  Future<void> save(ClassEntry entry) async {
    await saveAll([entry]);
  }

  @override
  Future<void> saveAll(
    List<ClassEntry> entries, {
    List<String> deleteIds = const [],
  }) async {
    final root = await _store.readRoot();
    final list = (root[_key] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    if (deleteIds.isNotEmpty) {
      final remove = deleteIds.toSet();
      list.removeWhere((e) => remove.contains(e['id'] as String));
    }

    for (final entry in entries) {
      final map = entry.toMap();
      final index = list.indexWhere((e) => e['id'] == entry.id);
      if (index >= 0) {
        list[index] = map;
      } else {
        list.add(map);
      }
    }

    root[_key] = list;
    await _store.writeRoot(root);
  }

  @override
  Future<void> delete(String id) async {
    await saveAll(const [], deleteIds: [id]);
  }

  Future<List<ClassEntry>> _readEntries() async {
    final root = await _store.readRoot();
    final list = root[_key] as List<dynamic>? ?? [];
    return list
        .map((e) => ClassEntry.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  int _compare(ClassEntry a, ClassEntry b) {
    final day = a.weekday.compareTo(b.weekday);
    if (day != 0) return day;
    return a.startTime.compareTo(b.startTime);
  }
}
