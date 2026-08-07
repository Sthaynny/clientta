class ClientProfile {
  const ClientProfile({
    required this.clientKey,
    required this.clientName,
    required this.clientPhone,
    this.serviceType,
    this.appointmentCount = 0,
    this.encounterCount = 0,
    this.lastActivityAt,
    this.nextAppointmentDate,
    this.nextAppointmentStartTime,
  });

  final String clientKey;
  final String clientName;
  final String clientPhone;
  final String? serviceType;
  final int appointmentCount;
  final int encounterCount;
  final DateTime? lastActivityAt;
  final DateTime? nextAppointmentDate;
  final String? nextAppointmentStartTime;

  int get totalInteractions => appointmentCount + encounterCount;
}
