import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';

final tMapServiceAppointment = <String, dynamic>{
  'id': 'appt-1',
  'clientName': 'Maria Silva',
  'clientPhone': '(11) 99999-0000',
  'serviceType': 'Empréstimo Consignado',
  'appointmentDate': '2026-03-10',
  'startTime': '09:00',
  'endTime': '10:00',
  'status': AppointmentStatus.agendado.value,
  'notes': 'Cliente interessado em refinanciamento',
};

final tInstanceServiceAppointment = ServiceAppointment.fromMap(
  tMapServiceAppointment,
);
