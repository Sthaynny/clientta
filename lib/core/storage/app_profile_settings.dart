import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_settings.dart';

/// Preferências locais do perfil (sem nuvem).
class AppProfileSettings {
  const AppProfileSettings({
    this.universityName,
    this.onboardingSeen = false,
    this.appointmentReminders = const AppointmentReminderSettings(),
  });

  final String? universityName;
  final bool onboardingSeen;
  final AppointmentReminderSettings appointmentReminders;

  static const profileRootKey = 'profile';

  factory AppProfileSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const AppProfileSettings();
    final name = map['universityName'];
    final seen = map['onboardingSeen'];
    final remindersRaw = map[AppointmentReminderSettings.profileKey];
    return AppProfileSettings(
      universityName:
          name is String && name.trim().isNotEmpty ? name.trim() : null,
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
    final name = universityName?.trim();
    if (name != null && name.isNotEmpty) {
      map['universityName'] = name;
    }
    if (onboardingSeen) {
      map['onboardingSeen'] = true;
    }
    map[AppointmentReminderSettings.profileKey] =
        appointmentReminders.toMap();
    return map;
  }

  AppProfileSettings copyWith({
    String? universityName,
    bool? onboardingSeen,
    AppointmentReminderSettings? appointmentReminders,
  }) {
    return AppProfileSettings(
      universityName: universityName ?? this.universityName,
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
    );
  }

  String get displayUniversityLabel =>
      (universityName != null && universityName!.isNotEmpty)
          ? universityName!
          : 'Sua universidade';
}
