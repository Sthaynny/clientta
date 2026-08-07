import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/core/storage/app_profile_settings.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_settings.dart';

void main() {
  test('onboardingSeen round-trip no mapa de perfil', () {
    const original = AppProfileSettings(onboardingSeen: true);
    final map = original.toMap();
    final restored = AppProfileSettings.fromMap(map);
    expect(restored.onboardingSeen, isTrue);
  });

  test('onboardingSeen false não persiste chave', () {
    const settings = AppProfileSettings(onboardingSeen: false);
    expect(settings.toMap().containsKey('onboardingSeen'), isFalse);
  });

  test('appointmentReminders round-trip no mapa de perfil', () {
    const original = AppProfileSettings(
      appointmentReminders: AppointmentReminderSettings(
        enabled: false,
        leadMinutes: 30,
      ),
    );
    final map = original.toMap();
    final restored = AppProfileSettings.fromMap(map);
    expect(restored.appointmentReminders.enabled, isFalse);
    expect(restored.appointmentReminders.leadMinutes, 30);
  });
}
