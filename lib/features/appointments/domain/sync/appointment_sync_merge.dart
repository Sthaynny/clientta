import 'package:clientta/features/appointments/domain/models/service_appointment.dart';

class AppointmentSyncMergeResult {
  const AppointmentSyncMergeResult({
    required this.toSaveLocal,
    required this.toUpsertRemote,
    required this.toDeleteRemote,
    required this.toDeleteLocal,
  });

  final List<ServiceAppointment> toSaveLocal;
  final List<ServiceAppointment> toUpsertRemote;
  final List<String> toDeleteRemote;
  final List<String> toDeleteLocal;
}

abstract final class AppointmentSyncMerge {
  static AppointmentSyncMergeResult merge({
    required List<ServiceAppointment> local,
    required List<ServiceAppointment> remote,
    required Set<String> pendingDeleteIds,
  }) {
    final localById = {for (final e in local) e.id: e};
    final remoteById = {for (final e in remote) e.id: e};
    final allIds = {...localById.keys, ...remoteById.keys, ...pendingDeleteIds};

    final toSaveLocal = <ServiceAppointment>[];
    final toUpsertRemote = <ServiceAppointment>[];
    final toDeleteRemote = <String>[];
    final toDeleteLocal = <String>[];

    for (final id in allIds) {
      if (pendingDeleteIds.contains(id)) {
        toDeleteRemote.add(id);
        toDeleteLocal.add(id);
        continue;
      }

      final localEntry = localById[id];
      final remoteEntry = remoteById[id];

      if (localEntry == null && remoteEntry != null) {
        toSaveLocal.add(remoteEntry);
        continue;
      }

      if (localEntry != null && remoteEntry == null) {
        toUpsertRemote.add(localEntry);
        continue;
      }

      if (localEntry != null && remoteEntry != null) {
        final winner = _pickWinner(localEntry, remoteEntry);
        if (!_isSameAppointment(localEntry, winner)) {
          toSaveLocal.add(winner);
        }
        if (!_isSameAppointment(remoteEntry, winner)) {
          toUpsertRemote.add(winner);
        }
      }
    }

    return AppointmentSyncMergeResult(
      toSaveLocal: toSaveLocal,
      toUpsertRemote: toUpsertRemote,
      toDeleteRemote: toDeleteRemote,
      toDeleteLocal: toDeleteLocal,
    );
  }

  static ServiceAppointment _pickWinner(
    ServiceAppointment local,
    ServiceAppointment remote,
  ) {
    final localAt = local.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final remoteAt = remote.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    if (remoteAt.isAfter(localAt)) return remote;
    if (localAt.isAfter(remoteAt)) return local;
    return remote;
  }

  static bool _isSameAppointment(ServiceAppointment a, ServiceAppointment b) {
    return a.clientName == b.clientName &&
        a.clientPhone == b.clientPhone &&
        a.serviceType == b.serviceType &&
        a.appointmentDate == b.appointmentDate &&
        a.startTime == b.startTime &&
        a.endTime == b.endTime &&
        a.status == b.status &&
        a.notes == b.notes &&
        a.seriesId == b.seriesId &&
        a.updatedAt == b.updatedAt;
  }
}
