import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_settings.dart';

/// Preferências locais do perfil (sem nuvem).
class AppProfileSettings {
  const AppProfileSettings({
    this.onboardingSeen = false,
    this.appointmentReminders = const AppointmentReminderSettings(),
  });

  final bool onboardingSeen;
  final AppointmentReminderSettings appointmentReminders;

  static const profileRootKey = 'profile';

  factory AppProfileSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const AppProfileSettings();
    final seen = map['onboardingSeen'];
    final remindersRaw = map[AppointmentReminderSettings.profileKey];
    return AppProfileSettings(
      onboardingSeen: seen == true,
      appointmentReminders: remindersRaw is Map
          ? AppointmentReminderSettings.fromMap(
            Map<String, dynamic>.from(remindersRaw),
          )
          : const AppointmentReminderSettings(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (onboardingSeen) {
      map['onboardingSeen'] = true;
    }
    map[AppointmentReminderSettings.profileKey] =
        appointmentReminders.toMap();
    return map;
  }

  AppProfileSettings copyWith({
    bool? onboardingSeen,
    AppointmentReminderSettings? appointmentReminders,
  }) {
    return AppProfileSettings(
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
    );
  }
}
