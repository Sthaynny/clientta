class ClientCareArgs {
  const ClientCareArgs({
    required this.clientName,
    required this.clientPhone,
    this.serviceType,
    this.appointmentId,
  });

  final String clientName;
  final String clientPhone;
  final String? serviceType;
  final String? appointmentId;
}
