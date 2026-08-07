import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/features/appointments/domain/appointment_client_match.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import '../../mock/model_mock.dart';

void main() {
  group('appointment client match', () {
    test('buildAppointmentSlotId ignora máscara do telefone', () {
      final first = buildAppointmentSlotId(
        clientPhone: '(83) 98130-4214',
        appointmentDate: DateTime(2026, 8, 7),
        startTime: '09:00',
      );
      final second = buildAppointmentSlotId(
        clientPhone: '83981304214',
        appointmentDate: DateTime(2026, 8, 7),
        startTime: '09:00',
      );

      expect(first, second);
    });

    test('buildAppointmentSlotId muda com data ou horário', () {
      final base = buildAppointmentSlotId(
        clientPhone: '83981304214',
        appointmentDate: DateTime(2026, 8, 7),
        startTime: '09:00',
      );
      final otherDate = buildAppointmentSlotId(
        clientPhone: '83981304214',
        appointmentDate: DateTime(2026, 8, 8),
        startTime: '09:00',
      );
      final otherTime = buildAppointmentSlotId(
        clientPhone: '83981304214',
        appointmentDate: DateTime(2026, 8, 7),
        startTime: '10:00',
      );

      expect(base, isNot(otherDate));
      expect(base, isNot(otherTime));
    });

    test('findClientNameByPhone retorna o nome mais recente', () {
      final appointments = [
        tInstanceServiceAppointment.copyWith(
          id: 'older',
          clientName: 'Maria Antiga',
          clientPhone: '(11) 99999-0000',
          appointmentDate: DateTime(2026, 3, 1),
        ),
        tInstanceServiceAppointment.copyWith(
          id: 'newer',
          clientName: 'Maria Silva',
          clientPhone: '11999990000',
          appointmentDate: DateTime(2026, 3, 10),
        ),
      ];

      final resolved = findClientNameByPhone(
        appointments: appointments,
        clientPhone: '(11) 99999-0000',
      );

      expect(resolved, 'Maria Silva');
    });

    test('findAppointmentAtSlot localiza agendamento existente', () {
      final existing = tInstanceServiceAppointment.copyWith(
        clientPhone: '(83) 98130-4214',
        appointmentDate: DateTime(2026, 8, 7),
        startTime: '09:00',
      );

      final match = findAppointmentAtSlot(
        appointments: [existing],
        clientPhone: '83981304214',
        appointmentDate: DateTime(2026, 8, 7),
        startTime: '09:00',
      );

      expect(match, existing);
    });
  });
}
