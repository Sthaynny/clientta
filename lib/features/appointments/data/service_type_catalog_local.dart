import 'package:clientta/core/storage/device_json_store.dart';
import 'package:clientta/features/appointments/domain/service_type_catalog.dart';

class ServiceTypeCatalogLocal {
  ServiceTypeCatalogLocal(this._store);

  final DeviceJsonStore _store;
  static const _key = 'serviceTypes';

  Future<List<String>> readSaved() async {
    final root = await _store.readRoot();
    final list = root[_key] as List<dynamic>? ?? [];
    return list.map((entry) => entry.toString().trim()).where((e) => e.isNotEmpty).toList();
  }

  Future<void> addIfNew(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;

    final saved = await readSaved();
    if (isKnownServiceType(trimmed, saved)) return;

    final root = await _store.readRoot();
    final list = (root[_key] as List<dynamic>? ?? [])
        .map((entry) => entry.toString().trim())
        .where((entry) => entry.isNotEmpty)
        .toList();
    if (isKnownServiceType(trimmed, list)) return;

    list.add(trimmed);
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    root[_key] = list;
    await _store.writeRoot(root);
  }
}
