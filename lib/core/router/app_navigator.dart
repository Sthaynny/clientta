import 'package:flutter/material.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_payload.dart';

/// Navegação global (notificações, deep links).
abstract final class AppNavigator {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static void openHome() {
    key.currentState?.pushNamedAndRemoveUntil(
      AppRouters.home.path,
      (_) => false,
    );
  }

  static void handleReminderNotificationPayload(String? payload) {
    final navigator = key.currentState;
    if (navigator == null) return;

    final careArgs = AppointmentReminderPayload.decodeCareArgs(payload);
    navigator.pushNamedAndRemoveUntil(AppRouters.home.path, (_) => false);

    if (careArgs != null) {
      navigator.pushNamed(AppRouters.clientCare.path, arguments: careArgs);
    }
  }
}
