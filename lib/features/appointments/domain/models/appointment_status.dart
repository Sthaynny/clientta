enum AppointmentStatus {
  agendado('agendado'),
  concluido('concluido'),
  cancelado('cancelado');

  const AppointmentStatus(this.value);

  final String value;

  static AppointmentStatus fromValue(String value) {
    return AppointmentStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => AppointmentStatus.agendado,
    );
  }

  String get label => switch (this) {
    AppointmentStatus.agendado => 'Agendado',
    AppointmentStatus.concluido => 'Concluído',
    AppointmentStatus.cancelado => 'Cancelado',
  };
}
