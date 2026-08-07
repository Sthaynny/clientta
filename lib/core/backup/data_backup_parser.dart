import 'dart:convert';

/// Resultado da restauração de backup para feedback na UI.
class DataBackupImportSummary {
  const DataBackupImportSummary({
    required this.appointmentCount,
    required this.encounterNoteCount,
  });

  final int appointmentCount;
  final int encounterNoteCount;
}

/// Normaliza e valida JSON de backup exportado pelo Clientta.
abstract final class DataBackupParser {
  static const allowedDataKeys = {
    'appointments',
    'encounterNotes',
    'profile',
  };

  static Map<String, dynamic>? parseRoot(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;

      final map = Map<String, dynamic>.from(decoded);
      final data = _extractData(map);
      if (data == null) return null;

      return sanitizeData(data);
    } on FormatException {
      return null;
    }
  }

  static Map<String, dynamic>? _extractData(Map<String, dynamic> map) {
    final nested = map['data'];
    if (nested is Map) {
      final schema = map['schemaVersion'];
      if (schema != null && schema != 1) return null;
      if (map['app'] != null && map['app'] != 'clientta') return null;
      return Map<String, dynamic>.from(nested);
    }

    if (map.containsKey('appointments') || map.containsKey('encounterNotes')) {
      return map;
    }

    return null;
  }

  static Map<String, dynamic> sanitizeData(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};
    for (final key in allowedDataKeys) {
      final value = data[key];
      if (value == null) continue;
      if (key == 'appointments' || key == 'encounterNotes') {
        if (value is List) sanitized[key] = value;
      } else if (key == 'profile' && value is Map) {
        sanitized[key] = Map<String, dynamic>.from(value);
      }
    }
    return sanitized;
  }

  static DataBackupImportSummary summarize(Map<String, dynamic> data) {
    return DataBackupImportSummary(
      appointmentCount: _listLength(data['appointments']),
      encounterNoteCount: _listLength(data['encounterNotes']),
    );
  }

  static int _listLength(Object? value) {
    return value is List ? value.length : 0;
  }
}
