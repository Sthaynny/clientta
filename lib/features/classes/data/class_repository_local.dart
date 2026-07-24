import 'package:ufersa_hub/core/storage/device_json_store.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/classes/domain/repositories/class_repository.dart';

class ClassRepositoryLocal implements ClassRepository {
  ClassRepositoryLocal(this._store);

  final DeviceJsonStore _store;
  static const _key = 'classes';

  @override
  Future<List<ClassEntry>> getAll() async {
    final root = await _store.readRoot();
    final list = root[_key] as List<dynamic>? ?? [];
    return list
        .map((e) => ClassEntry.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) {
        final day = a.weekday.compareTo(b.weekday);
        if (day != 0) return day;
        return a.startTime.compareTo(b.startTime);
      });
  }

  @override
  Future<void> save(ClassEntry entry) async {
    final root = await _store.readRoot();
    final list = (root[_key] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final index = list.indexWhere((e) => e['id'] == entry.id);
    final map = entry.toMap();
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
}
