import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/features/client_care/domain/care_timeline_builder.dart';
import 'package:clientta/features/client_care/domain/encounter_session.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';

void main() {
  group('buildCareTimeline', () {
    test('ordena notas de encontro da mais recente para a mais antiga', () {
      final encounterNotes = [
        EncounterNote(
          id: 'note-1',
          clientPhone: '(11) 99999-0000',
          clientName: 'Maria',
          body: 'Cliente pediu retorno na sexta.',
          createdAt: DateTime(2026, 3, 12, 15, 30),
        ),
        EncounterNote(
          id: 'note-2',
          clientPhone: '(11) 99999-0000',
          clientName: 'Maria',
          body: 'Negociação fechada.',
          createdAt: DateTime(2026, 3, 11, 10),
        ),
      ];

      final timeline = buildCareTimeline(encounterNotes: encounterNotes);

      expect(timeline.length, 2);
      expect(timeline.first.body, 'Cliente pediu retorno na sexta.');
      expect(timeline.last.body, 'Negociação fechada.');
    });

    test('retorna lista vazia sem notas', () {
      final timeline = buildCareTimeline(encounterNotes: const []);

      expect(timeline, isEmpty);
    });
  });

  group('hasEncounterSessionToday', () {
    test('detecta sessão iniciada no mesmo dia', () {
      final reference = DateTime(2026, 8, 7, 16);

      final hasSession = hasEncounterSessionToday(
        [
          EncounterNote(
            id: 'note-1',
            clientPhone: '11999990000',
            clientName: 'Maria',
            body: encounterStartedDefaultBodyString,
            createdAt: DateTime(2026, 8, 7, 9),
          ),
        ],
        sessionBody: encounterStartedDefaultBodyString,
        reference: reference,
      );

      expect(hasSession, isTrue);
    });

    test('ignora sessão de outro dia', () {
      final reference = DateTime(2026, 8, 7, 16);

      final hasSession = hasEncounterSessionToday(
        [
          EncounterNote(
            id: 'note-1',
            clientPhone: '11999990000',
            clientName: 'Maria',
            body: encounterStartedDefaultBodyString,
            createdAt: DateTime(2026, 8, 6, 9),
          ),
        ],
        sessionBody: encounterStartedDefaultBodyString,
        reference: reference,
      );

      expect(hasSession, isFalse);
    });
  });
}
