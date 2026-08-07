import 'dart:async';

import 'package:flutter/material.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';
import 'package:clientta/features/billing/shared/utils/billing_checkout_pending.dart';
import 'package:clientta/features/billing/shared/utils/billing_return_url.dart';
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

  static void handleBillingDeepLink(Uri uri) {
    if (!isBillingCheckoutDeepLink(uri)) return;

    final navigator = key.currentState;
    if (navigator == null) return;

    BillingCheckoutPending.instance.mark();

    navigator.pushNamedAndRemoveUntil(AppRouters.home.path, (_) => false);
    navigator.pushNamed(AppRouters.planSettings.path);

    unawaited(
      dependency<BillingRepository>().syncSubscriptionStatus().then(
        (subscription) {
          if (subscription.allowsOperationalAccess) {
            BillingCheckoutPending.instance.clear();
          }
        },
      ).catchError((_) {}),
    );
  }
}
