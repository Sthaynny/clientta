import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';
import 'package:clientta/features/clients/domain/client_profile_aggregator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildClientProfiles', () {
    test('groups appointments and notes by phone', () {
      final profiles = buildClientProfiles(
        appointments: [
          ServiceAppointment(
            id: '1',
            clientName: 'Maria Silva',
            clientPhone: '(11) 99999-0001',
            serviceType: 'Seguro auto',
            appointmentDate: DateTime(2026, 8, 7),
            startTime: '10:00',
            endTime: '10:30',
            status: AppointmentStatus.agendado.value,
          ),
          ServiceAppointment(
            id: '2',
            clientName: 'Maria Silva',
            clientPhone: '(11) 99999-0001',
            serviceType: 'Seguro auto',
            appointmentDate: DateTime(2026, 8, 1),
            startTime: '09:00',
            endTime: '09:30',
            status: AppointmentStatus.concluido.value,
          ),
        ],
        encounterNotes: [
          EncounterNote(
            id: 'n1',
            clientPhone: '(11) 99999-0001',
            clientName: 'Maria Silva',
            serviceType: 'Seguro auto',
            body: 'Cliente pediu retorno.',
            createdAt: DateTime(2026, 8, 5, 14, 30),
          ),
        ],
        now: DateTime(2026, 8, 7, 8),
      );

      expect(profiles, hasLength(1));
      expect(profiles.first.clientName, 'Maria Silva');
      expect(profiles.first.appointmentCount, 2);
      expect(profiles.first.encounterCount, 1);
      expect(profiles.first.nextAppointmentDate, DateTime(2026, 8, 7));
      expect(profiles.first.nextAppointmentStartTime, '10:00');
    });

    test('filters profiles by name or phone', () {
      final profiles = buildClientProfiles(
        appointments: [
          ServiceAppointment(
            id: '1',
            clientName: 'João Souza',
            clientPhone: '(11) 98888-0002',
            serviceType: 'Crédito',
            appointmentDate: DateTime(2026, 8, 3),
            startTime: '11:00',
            endTime: '11:30',
            status: AppointmentStatus.agendado.value,
          ),
          ServiceAppointment(
            id: '2',
            clientName: 'Ana Lima',
            clientPhone: '(11) 97777-0003',
            serviceType: 'Consórcio',
            appointmentDate: DateTime(2026, 8, 2),
            startTime: '15:00',
            endTime: '15:30',
            status: AppointmentStatus.agendado.value,
          ),
        ],
        encounterNotes: const [],
      );

      final byName = filterClientProfiles(profiles, 'ana');
      final byPhone = filterClientProfiles(profiles, '8888');

      expect(byName, hasLength(1));
      expect(byName.first.clientName, 'Ana Lima');
      expect(byPhone, hasLength(1));
      expect(byPhone.first.clientName, 'João Souza');
    });
  });
}
