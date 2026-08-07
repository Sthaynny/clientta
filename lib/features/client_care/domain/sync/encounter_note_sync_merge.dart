import 'package:clientta/features/client_care/domain/models/encounter_note.dart';

class EncounterNoteSyncMergeResult {
  const EncounterNoteSyncMergeResult({
    required this.toSaveLocal,
    required this.toUpsertRemote,
    required this.toDeleteRemote,
    required this.toDeleteLocal,
  });

  final List<EncounterNote> toSaveLocal;
  final List<EncounterNote> toUpsertRemote;
  final List<String> toDeleteRemote;
  final List<String> toDeleteLocal;
}

abstract final class EncounterNoteSyncMerge {
  static EncounterNoteSyncMergeResult merge({
    required List<EncounterNote> local,
    required List<EncounterNote> remote,
    required Set<String> pendingDeleteIds,
  }) {
    final localById = {for (final e in local) e.id: e};
    final remoteById = {for (final e in remote) e.id: e};
    final allIds = {...localById.keys, ...remoteById.keys, ...pendingDeleteIds};

    final toSaveLocal = <EncounterNote>[];
    final toUpsertRemote = <EncounterNote>[];
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
        if (!_isSameNote(localEntry, winner)) {
          toSaveLocal.add(winner);
        }
        if (!_isSameNote(remoteEntry, winner)) {
          toUpsertRemote.add(winner);
        }
      }
    }

    return EncounterNoteSyncMergeResult(
      toSaveLocal: toSaveLocal,
      toUpsertRemote: toUpsertRemote,
      toDeleteRemote: toDeleteRemote,
      toDeleteLocal: toDeleteLocal,
    );
  }

  static EncounterNote _pickWinner(EncounterNote local, EncounterNote remote) {
    final localAt = local.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final remoteAt = remote.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    if (remoteAt.isAfter(localAt)) return remote;
    if (localAt.isAfter(remoteAt)) return local;
    return remote;
  }

  static bool _isSameNote(EncounterNote a, EncounterNote b) {
    return a.clientPhone == b.clientPhone &&
        a.clientName == b.clientName &&
        a.serviceType == b.serviceType &&
        a.appointmentId == b.appointmentId &&
        a.body == b.body &&
        a.createdAt == b.createdAt &&
        a.updatedAt == b.updatedAt;
  }
}
