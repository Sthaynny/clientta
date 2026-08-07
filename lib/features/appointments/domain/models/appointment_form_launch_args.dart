import 'package:clientta/features/appointments/domain/models/service_appointment.dart';

class AppointmentFormLaunchArgs {
  const AppointmentFormLaunchArgs({
    this.editEntry,
    this.prefillClientName,
    this.prefillClientPhone,
    this.prefillServiceType,
    this.lockClientFields = false,
  });

  final ServiceAppointment? editEntry;
  final String? prefillClientName;
  final String? prefillClientPhone;
  final String? prefillServiceType;
  final bool lockClientFields;

  bool get isEdit => editEntry != null;

  factory AppointmentFormLaunchArgs.prefill({
    required String clientName,
    required String clientPhone,
    String? serviceType,
  }) {
    return AppointmentFormLaunchArgs(
      prefillClientName: clientName,
      prefillClientPhone: clientPhone,
      prefillServiceType: serviceType,
      lockClientFields: true,
    );
  }
}
