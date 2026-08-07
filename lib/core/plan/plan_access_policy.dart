import 'package:clientta/features/billing/domain/entities/user_subscription.dart';

abstract final class PlanAccessPolicy {
  static bool canAccessOperationalFeatures(UserSubscription subscription) {
    return subscription.allowsOperationalAccess;
  }

  static bool shouldShowPlanGate(UserSubscription subscription) {
    return !canAccessOperationalFeatures(subscription);
  }
}
