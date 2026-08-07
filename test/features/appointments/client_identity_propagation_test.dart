import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/features/appointments/domain/client_identity_propagation.dart';
import 'package:clientta/features/client_care/domain/client_identity_propagation.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';
import '../../mock/model_mock.dart';

void main() {
  group('client identity propagation', () {
    test('clientIdentityChanged detecta alteração de nome ou telefone', () {
      expect(
        clientIdentityChanged(
          previousPhone: '(83) 98130-4214',
          newPhone: '(83) 98130-4214',
          previousName: 'Igor',
          newName: 'Teste cliente',
        ),
        isTrue,
      );
      expect(
        clientIdentityChanged(
          previousPhone: '(83) 98130-4214',
          newPhone: '83999990000',
          previousName: 'Igor',
          newName: 'Igor',
        ),
        isTrue,
      );
      expect(
        clientIdentityChanged(
          previousPhone: '(83) 98130-4214',
          newPhone: '83981304214',
          previousName: 'Igor',
          newName: 'Igor',
        ),
        isFalse,
      );
    });

    test('propagateClientIdentityToAppointments atualiza todos com o mesmo telefone', () {
      final appointments = [
        tInstanceServiceAppointment.copyWith(
          id: 'edited',
          clientName: 'Teste cliente',
          clientPhone: '(83) 98130-4214',
          appointmentDate: DateTime(2026, 8, 7),
        ),
        tInstanceServiceAppointment.copyWith(
          id: 'other',
          clientName: 'IGor Sthaynny',
          clientPhone: '83981304214',
          appointmentDate: DateTime(2026, 8, 10),
        ),
        tInstanceServiceAppointment.copyWith(
          id: 'different',
          clientName: 'Maria',
          clientPhone: '(11) 99999-0000',
        ),
      ];

      final updates = propagateClientIdentityToAppointments(
        appointments: appointments,
        previousPhone: '(83) 98130-4214',
        newClientName: 'Teste cliente',
        newClientPhone: '(83) 98130-4214',
        excludeIds: {'edited'},
      );

      expect(updates, hasLength(1));
      expect(updates.single.id, 'other');
      expect(updates.single.clientName, 'Teste cliente');
    });

    test('propagateClientIdentityToEncounterNotes atualiza notas do cliente', () {
      final notes = [
        EncounterNote(
          id: '1',
          clientPhone: '(83) 98130-4214',
          clientName: 'IGor Sthaynny',
          body: 'Primeiro contato',
          createdAt: DateTime(2026, 8, 1),
        ),
        EncounterNote(
          id: '2',
          clientPhone: '83981304214',
          clientName: 'IGor Sthaynny',
          body: 'Retorno',
          createdAt: DateTime(2026, 8, 5),
        ),
        EncounterNote(
          id: '3',
          clientPhone: '(11) 99999-0000',
          clientName: 'Maria',
          body: 'Outro cliente',
          createdAt: DateTime(2026, 8, 6),
        ),
      ];

      final updates = propagateClientIdentityToEncounterNotes(
        notes: notes,
        previousPhone: '(83) 98130-4214',
        newClientName: 'Teste cliente',
        newClientPhone: '(83) 98130-4214',
      );

      expect(updates, hasLength(2));
      expect(updates.map((note) => note.id), containsAll(['1', '2']));
      expect(updates.every((note) => note.clientName == 'Teste cliente'), isTrue);
    });
  });
}
