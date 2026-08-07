import 'package:clientta/features/billing/domain/entities/subscription_checkout.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';

abstract class BillingRepository {
  Future<Map<String, dynamic>> getPlanPricing();

  Future<SubscriptionCheckout> createSubscription({
    required String planId,
    required String returnUrl,
  });

  Future<UserSubscription> syncSubscriptionStatus();

  Future<UserSubscription> completeSandboxSubscription();

  Future<void> cancelSubscription();
}
