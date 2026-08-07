import 'package:clientta/core/storage/device_json_store.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryLocal implements AppointmentRepository {
  AppointmentRepositoryLocal(this._store);

  final DeviceJsonStore _store;
  static const _key = 'appointments';

  @override
  Future<List<ServiceAppointment>> getAll() async {
    final list = await _readEntries();
    return list..sort(_compare);
  }

  @override
  Future<void> save(ServiceAppointment entry) async {
    await saveAll([entry]);
  }

  @override
  Future<void> saveAll(
    List<ServiceAppointment> entries, {
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

  Future<List<ServiceAppointment>> _readEntries() async {
    final root = await _store.readRoot();
    final list = root[_key] as List<dynamic>? ?? [];
    return list
        .map(
          (e) => ServiceAppointment.fromMap(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  int _compare(ServiceAppointment a, ServiceAppointment b) {
    final date = a.appointmentDate.compareTo(b.appointmentDate);
    if (date != 0) return date;
    return a.startTime.compareTo(b.startTime);
  }
}
