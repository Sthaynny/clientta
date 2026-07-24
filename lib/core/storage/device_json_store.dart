import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Persistência local em arquivo JSON no dispositivo (sem servidor nem SQL).
class DeviceJsonStore {
  static const fileName = 'conectafersa_daily.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  Future<Map<String, dynamic>> readRoot() async {
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
