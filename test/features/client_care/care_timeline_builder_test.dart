import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/client_care/domain/care_timeline_builder.dart';
import 'package:clientta/features/client_care/domain/models/care_timeline_entry.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';

void main() {
  group('buildCareTimeline', () {
    test('combina notas de encontro e agendamentos legados', () {
      final encounterNotes = [
        EncounterNote(
          id: 'note-1',
          clientPhone: '(11) 99999-0000',
          clientName: 'Maria',
          body: 'Cliente pediu retorno na sexta.',
          createdAt: DateTime(2026, 3, 12, 15, 30),
        ),
      ];

      final appointments = [
        _appointment(
          id: 'apt-1',
          notes: 'Proposta enviada por e-mail.',
          date: DateTime(2026, 3, 10),
        ),
        _appointment(
          id: 'apt-2',
          notes: 'Nota vinculada',
          date: DateTime(2026, 3, 11),
        ),
      ];

      final linkedNote = EncounterNote(
        id: 'note-2',
        clientPhone: '(11) 99999-0000',
        clientName: 'Maria',
        appointmentId: 'apt-2',
        body: 'Negociação fechada.',
        createdAt: DateTime(2026, 3, 11, 10),
      );

      final timeline = buildCareTimeline(
        clientPhone: '11999990000',
        encounterNotes: [...encounterNotes, linkedNote],
        appointments: appointments,
      );

      expect(timeline.length, 3);
      expect(timeline.first.body, 'Cliente pediu retorno na sexta.');
      expect(
        timeline.any((entry) => entry.source == CareTimelineSource.appointment),
        isTrue,
      );
      expect(
        timeline.any((entry) => entry.id == 'appointment-apt-2'),
        isFalse,
      );
    });

    test('retorna lista vazia sem notas nem agendamentos', () {
      final timeline = buildCareTimeline(
        clientPhone: '11999990000',
        encounterNotes: const [],
        appointments: const [],
      );

      expect(timeline, isEmpty);
    });
  });
}

ServiceAppointment _appointment({
  required String id,
  required DateTime date,
  String? notes,
}) {
  return ServiceAppointment(
    id: id,
    clientName: 'Maria',
    clientPhone: '(11) 99999-0000',
    serviceType: 'Empréstimo Consignado',
    appointmentDate: date,
    startTime: '09:00',
    endTime: '10:00',
    status: AppointmentStatus.concluido.value,
    notes: notes,
  );
}
