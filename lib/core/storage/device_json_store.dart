import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Persistência local em arquivo JSON no dispositivo (sem servidor nem SQL).
class DeviceJsonStore {
  static const fileName = 'clientta_data.json';
  static const legacyFileName = 'university_hub_daily.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  Future<void> _migrateLegacyIfNeeded(Directory dir) async {
    final current = File('${dir.path}/$fileName');
    if (await current.exists()) return;

    final legacy = File('${dir.path}/$legacyFileName');
    if (!await legacy.exists()) return;

    await legacy.rename(current.path);
  }

  Future<Map<String, dynamic>> readRoot() async {
    final dir = await getApplicationDocumentsDirectory();
    await _migrateLegacyIfNeeded(dir);
    final file = await _file();
    if (!await file.exists()) {
      return {};
    }
    final raw = await file.readAsString();
    if (raw.trim().isEmpty) {
      return {};
    }
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return {};
  }

  Future<void> writeRoot(Map<String, dynamic> data) async {
    final file = await _file();
    await file.writeAsString(jsonEncode(data));
  }
}
