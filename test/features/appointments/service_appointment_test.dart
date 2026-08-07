import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import '../../mock/model_mock.dart';

void main() {
  test('ServiceAppointment fromMap/toMap round-trip', () {
    final restored = ServiceAppointment.fromMap(tMapServiceAppointment);
    expect(restored.id, tInstanceServiceAppointment.id);
    expect(restored.clientName, 'Maria Silva');
    expect(restored.clientPhone, '(11) 99999-0000');
    expect(restored.serviceType, 'Empréstimo Consignado');
    expect(restored.status, AppointmentStatus.agendado.value);
    expect(restored.toMap(), tMapServiceAppointment);
  });

  test('ServiceAppointment fromMap parseia updatedAt', () {
    final map = Map<String, dynamic>.from(tMapServiceAppointment)
      ..['updatedAt'] = '2026-03-10T12:30:00.000';
    final restored = ServiceAppointment.fromMap(map);
    expect(restored.updatedAt, DateTime.parse('2026-03-10T12:30:00.000'));
  });

  test('ServiceAppointment copyWith atualiza status', () {
    final updated = tInstanceServiceAppointment.copyWith(
      status: AppointmentStatus.concluido.value,
    );
    expect(updated.status, AppointmentStatus.concluido.value);
    expect(updated.clientName, tInstanceServiceAppointment.clientName);
  });

  test('ServiceAppointment copyWith clearNotes remove observações', () {
    final updated = tInstanceServiceAppointment.copyWith(clearNotes: true);
    expect(updated.notes, isNull);
  });
}
