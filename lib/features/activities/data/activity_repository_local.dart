import 'package:university_hub/core/storage/device_json_store.dart';
import 'package:university_hub/features/activities/domain/models/activity_entry.dart';
import 'package:university_hub/features/activities/domain/repositories/activity_repository.dart';

class ActivityRepositoryLocal implements ActivityRepository {
  ActivityRepositoryLocal(this._store);

  final DeviceJsonStore _store;
  static const _key = 'activities';

  @override
  Future<List<ActivityEntry>> getAll() async {
    final root = await _store.readRoot();
    final list = root[_key] as List<dynamic>? ?? [];
    return list
        .map((e) => ActivityEntry.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> save(ActivityEntry entry) async {
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
