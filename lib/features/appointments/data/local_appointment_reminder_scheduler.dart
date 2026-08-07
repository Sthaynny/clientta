import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:clientta/core/notifications/local_notifications_bootstrap.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_policy.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_scheduler.dart';

class LocalAppointmentReminderScheduler implements AppointmentReminderScheduler {
  LocalAppointmentReminderScheduler(
    this._plugin, {
    void Function(String? payload)? onNotificationTap,
  }) : _onNotificationTap = onNotificationTap;

  final FlutterLocalNotificationsPlugin _plugin;
  final void Function(String? payload)? _onNotificationTap;
  static const _androidChannelId = 'clientta_appointment_reminders';
  static const _androidChannelName = 'Lembretes de atendimento';

  @override
  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        _onNotificationTap?.call(response.payload);
      },
    );

    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        description: 'Avisos antes do horário de um atendimento agendado.',
        importance: Importance.high,
      ),
    );
  }

  @override
  Future<bool> requestPermissionsIfNeeded() async {
    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    final iosPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

    final androidGranted =
        await androidPlugin?.requestNotificationsPermission() ?? true;
    final iosGranted =
        await iosPlugin?.requestPermissions(alert: true, sound: true) ?? true;

    return androidGranted && iosGranted;
  }

  @override
  Future<void> scheduleAppointmentReminder({
    required ServiceAppointment appointment,
    required DateTime fireAt,
    required String title,
    required String body,
    String? payload,
  }) async {
    final notificationId = AppointmentReminderPolicy.notificationIdFor(
      appointment.id,
    );
    final scheduled = tz.TZDateTime.from(fireAt, tz.local);

    await _plugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      payload: payload,
      scheduledDate: scheduled,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          _androidChannelName,
          channelDescription:
              'Avisos antes do horário de um atendimento agendado.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancelAppointmentReminder(String appointmentId) async {
    await _plugin.cancel(
      id: AppointmentReminderPolicy.notificationIdFor(appointmentId),
    );
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAllPendingNotifications();
  }
}

/// Factory usada pelo GetIt após [ensureLocalNotificationsReady].
LocalAppointmentReminderScheduler createLocalAppointmentReminderScheduler({
  void Function(String? payload)? onNotificationTap,
}) {
  return LocalAppointmentReminderScheduler(
    LocalNotificationsBootstrap.plugin,
    onNotificationTap: onNotificationTap,
  );
}
