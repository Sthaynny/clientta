import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/features/appointments/domain/appointment_form_validation.dart';
import 'package:clientta/features/appointments/domain/appointment_list_grouping.dart';
import 'package:clientta/features/appointments/domain/appointment_series_generator.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';

ServiceAppointment _entry({
  required String id,
  required DateTime date,
  String startTime = '09:00',
  String? seriesId,
  String serviceType = 'Empréstimo Consignado',
}) {
  return ServiceAppointment(
    id: id,
    clientName: 'Maria Silva',
    clientPhone: '(11) 99999-0000',
    serviceType: serviceType,
    appointmentDate: date,
    startTime: startTime,
    endTime: '10:00',
    status: AppointmentStatus.agendado.value,
    seriesId: seriesId,
  );
}

void main() {
  group('groupAppointments', () {
    test('agrupa por data e série com ordenação decrescente', () {
      final groups = groupAppointments([
        _entry(id: '1', date: DateTime(2026, 3, 10)),
        _entry(id: '2', date: DateTime(2026, 3, 12)),
        _entry(
          id: '3',
          date: DateTime(2026, 3, 5),
          seriesId: 'series-1',
        ),
        _entry(
          id: '4',
          date: DateTime(2026, 3, 8),
          seriesId: 'series-1',
        ),
      ]);

      expect(groups, hasLength(3));
      expect(groups.first.entries.first.id, '2');
      expect(
        groups.any((group) => group.id == 'series:series-1'),
        isTrue,
      );
      expect(
        groups.any((group) => group.id == 'date:2026-03-10'),
        isTrue,
      );
    });
  });

  group('validateAppointmentFormFields', () {
    test('retorna erros por campo quando formulário inválido', () {
      final errors = validateAppointmentFormFields(
        clientName: '',
        clientPhone: '',
        serviceType: '',
        startTime: '10:00',
        endTime: '09:00',
      );

      expect(errors.hasErrors, isTrue);
      expect(errors.clientName, isNotNull);
      expect(errors.clientPhone, isNotNull);
      expect(errors.endTime, isNotNull);
    });

    test('não retorna erros quando formulário válido', () {
      final errors = validateAppointmentFormFields(
        clientName: 'Maria',
        clientPhone: '(11) 99999-0000',
        serviceType: 'Seguro Auto',
        startTime: '09:00',
        endTime: '10:00',
      );

      expect(errors.hasErrors, isFalse);
    });
  });

  group('buildRecurringAppointments', () {
    test('gera atendimentos com mesmo seriesId nos dias selecionados', () {
      final entries = buildRecurringAppointments(
        seriesId: 'series-1',
        anchorDate: DateTime(2026, 3, 9),
        weekdays: {DateTime.monday, DateTime.wednesday},
        clientName: 'Maria Silva',
        clientPhone: '(11) 99999-0000',
        serviceType: 'Seguro Auto',
        startTime: '09:00',
        endTime: '10:00',
        status: AppointmentStatus.agendado.value,
        weeks: 2,
      );

      expect(entries, isNotEmpty);
      expect(entries.every((entry) => entry.seriesId == 'series-1'), isTrue);
      expect(
        entries.every((entry) => entry.clientName == 'Maria Silva'),
        isTrue,
      );
    });
  });
}
