import 'package:university_hub/core/storage/app_profile_settings.dart';
import 'package:university_hub/core/storage/device_json_store.dart';

class AppProfileRepository {
  AppProfileRepository(this._store);

  final DeviceJsonStore _store;

  Future<AppProfileSettings> load() async {
    final root = await _store.readRoot();
    final raw = root[AppProfileSettings.profileRootKey];
    if (raw is Map<String, dynamic>) {
      return AppProfileSettings.fromMap(raw);
    }
    if (raw is Map) {
      return AppProfileSettings.fromMap(Map<String, dynamic>.from(raw));
    }
    return const AppProfileSettings();
  }

  Future<void> save(AppProfileSettings settings) async {
    final root = await _store.readRoot();
    final map = settings.toMap();
    if (map.isEmpty) {
      root.remove(AppProfileSettings.profileRootKey);
    } else {
      root[AppProfileSettings.profileRootKey] = map;
    }
    await _store.writeRoot(root);
  }
}
