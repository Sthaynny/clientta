import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';

void main() {
  group('EncounterNote', () {
    test('serializa e desserializa corretamente', () {
      final note = EncounterNote(
        id: '1',
        clientPhone: '11999990000',
        clientName: 'João',
        serviceType: 'Seguro Auto',
        appointmentId: 'apt-1',
        body: 'Retorno agendado.',
        createdAt: DateTime(2026, 3, 10, 14, 0),
        updatedAt: DateTime(2026, 3, 10, 14, 1),
      );

      final restored = EncounterNote.fromMap(note.toMap());

      expect(restored.id, note.id);
      expect(restored.clientPhone, note.clientPhone);
      expect(restored.clientName, note.clientName);
      expect(restored.serviceType, note.serviceType);
      expect(restored.appointmentId, note.appointmentId);
      expect(restored.body, note.body);
      expect(restored.createdAt, note.createdAt);
      expect(restored.updatedAt, note.updatedAt);
    });
  });
}
