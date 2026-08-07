import 'package:clientta/features/appointments/domain/models/service_type.dart';

List<String> mergeServiceTypes({
  required List<String> saved,
  required Iterable<String> fromAppointments,
}) {
  final seen = <String>{};
  final merged = <String>[];

  void add(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return;
    final key = value.toLowerCase();
    if (seen.add(key)) {
      merged.add(value);
    }
  }

  for (final type in ServiceType.all) {
    add(type);
  }
  for (final type in saved) {
    add(type);
  }
  for (final type in fromAppointments) {
    add(type);
  }

  merged.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return merged;
}

bool isKnownServiceType(String value, List<String> catalog) {
  final key = value.trim().toLowerCase();
  if (key.isEmpty) return false;
  return catalog.any((type) => type.toLowerCase() == key);
}
