import 'package:clientta/features/billing/domain/entities/billing_entitlement.dart';
import 'package:clientta/features/billing/domain/entities/subscription_checkout.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';

abstract class BillingRepository {
  Future<Map<String, dynamic>> getPlanPricing();

  Future<UserSubscription> getSubscription();

  Stream<UserSubscription> watchSubscription();

  Future<BillingEntitlement> syncEntitlements();

  Future<SubscriptionCheckout> createSubscription({
    required String planId,
    required String returnUrl,
  });

  Future<UserSubscription> syncSubscriptionStatus();

  Future<UserSubscription> completeSandboxSubscription();

  Future<UserSubscription> cancelSubscription();
}
