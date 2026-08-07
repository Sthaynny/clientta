import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/sync/appointment_sync_merge.dart';
import '../../mock/model_mock.dart';

ServiceAppointment _appointment({
  required String id,
  DateTime? updatedAt,
  String status = 'agendado',
}) {
  return tInstanceServiceAppointment.copyWith(
    id: id,
    updatedAt: updatedAt,
    status: status,
  );
}

void main() {
  group('AppointmentSyncMerge', () {
    test('envia local exclusivo para remoto', () {
      final local = [_appointment(id: 'local-1', updatedAt: DateTime(2026, 3, 10))];
      final result = AppointmentSyncMerge.merge(
        local: local,
        remote: const [],
        pendingDeleteIds: {},
      );

      expect(result.toUpsertRemote, local);
      expect(result.toSaveLocal, isEmpty);
      expect(result.toDeleteRemote, isEmpty);
    });

    test('baixa remoto exclusivo para local', () {
      final remote = [_appointment(id: 'remote-1', updatedAt: DateTime(2026, 3, 11))];
      final result = AppointmentSyncMerge.merge(
        local: const [],
        remote: remote,
        pendingDeleteIds: {},
      );

      expect(result.toSaveLocal, remote);
      expect(result.toUpsertRemote, isEmpty);
    });

    test('updatedAt mais recente no local vence', () {
      final localAt = DateTime(2026, 3, 12, 10);
      final remoteAt = DateTime(2026, 3, 12, 9);
      final local = [_appointment(id: 'shared', updatedAt: localAt)];
      final remote = [
        _appointment(id: 'shared', updatedAt: remoteAt).copyWith(
          clientName: 'Remoto',
        ),
      ];

      final result = AppointmentSyncMerge.merge(
        local: local,
        remote: remote,
        pendingDeleteIds: {},
      );

      expect(result.toUpsertRemote, local);
      expect(result.toSaveLocal, isEmpty);
    });

    test('updatedAt mais recente no remoto vence', () {
      final localAt = DateTime(2026, 3, 12, 8);
      final remoteAt = DateTime(2026, 3, 12, 11);
      final local = [
        _appointment(id: 'shared', updatedAt: localAt).copyWith(
          clientName: 'Local',
        ),
      ];
      final remote = [_appointment(id: 'shared', updatedAt: remoteAt)];

      final result = AppointmentSyncMerge.merge(
        local: local,
        remote: remote,
        pendingDeleteIds: {},
      );

      expect(result.toSaveLocal, remote);
      expect(result.toUpsertRemote, isEmpty);
    });

    test('propaga exclusões pendentes', () {
      final result = AppointmentSyncMerge.merge(
        local: [_appointment(id: 'gone', updatedAt: DateTime(2026, 3, 10))],
        remote: [_appointment(id: 'gone', updatedAt: DateTime(2026, 3, 9))],
        pendingDeleteIds: {'gone'},
      );

      expect(result.toDeleteRemote, ['gone']);
      expect(result.toDeleteLocal, ['gone']);
      expect(result.toSaveLocal, isEmpty);
      expect(result.toUpsertRemote, isEmpty);
    });
  });
}
