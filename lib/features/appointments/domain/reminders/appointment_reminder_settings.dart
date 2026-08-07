/// Preferências de lembretes locais (Pro) — persistidas em `profile`.
class AppointmentReminderSettings {
  const AppointmentReminderSettings({
    this.enabled = true,
    this.leadMinutes = defaultLeadMinutes,
  });

  static const defaultLeadMinutes = 15;
  static const profileKey = 'appointmentReminders';

  final bool enabled;
  final int leadMinutes;

  factory AppointmentReminderSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const AppointmentReminderSettings();
    final lead = map['leadMinutes'];
    return AppointmentReminderSettings(
      enabled: map['enabled'] != false,
      leadMinutes: lead is int && lead > 0 ? lead : defaultLeadMinutes,
    );
  }

  Map<String, dynamic> toMap() => {
    'enabled': enabled,
    'leadMinutes': leadMinutes,
  };

  AppointmentReminderSettings copyWith({
    bool? enabled,
    int? leadMinutes,
  }) {
    return AppointmentReminderSettings(
      enabled: enabled ?? this.enabled,
      leadMinutes: leadMinutes ?? this.leadMinutes,
    );
  }
}
