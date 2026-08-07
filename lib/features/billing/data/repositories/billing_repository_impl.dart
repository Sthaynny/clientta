import 'package:clientta/features/billing/data/datasources/firebase_billing_datasource.dart';
import 'package:clientta/features/billing/domain/entities/billing_entitlement.dart';
import 'package:clientta/features/billing/domain/entities/plan_pricing_catalog.dart';
import 'package:clientta/features/billing/domain/entities/subscription_checkout.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';

class BillingRepositoryImpl implements BillingRepository {
  BillingRepositoryImpl(this._datasource);

  final FirebaseBillingDatasource _datasource;

  @override
  Future<Map<String, dynamic>> getPlanPricing() async {
    try {
      return await _datasource.getPlanPricing();
    } catch (_) {
      return PlanPricingCatalog.toMap();
    }
  }

  @override
  Future<UserSubscription> getSubscription() async {
    try {
      return await _datasource.getSubscription();
    } catch (_) {
      return UserSubscription.inactive;
    }
  }

  @override
  Stream<UserSubscription> watchSubscription() =>
      _datasource.watchSubscription();

  @override
  Future<BillingEntitlement> getBillingEntitlement() async {
    try {
      return await _datasource.getBillingEntitlement();
    } catch (_) {
      return BillingEntitlement.none;
    }
  }

  @override
  Future<BillingEntitlement> syncEntitlements() async {
    try {
      return await _datasource.syncEntitlements();
    } catch (_) {
      return BillingEntitlement.none;
    }
  }

  @override
  Future<SubscriptionCheckout> createSubscription({
    required String planId,
    required String returnUrl,
  }) =>
      _datasource.createSubscription(planId: planId, returnUrl: returnUrl);

  @override
  Future<UserSubscription> syncSubscriptionStatus() =>
      _datasource.syncSubscriptionStatus();

  @override
  Future<UserSubscription> completeSandboxSubscription() =>
      _datasource.completeSandboxSubscription();

  @override
  Future<UserSubscription> cancelSubscription() =>
      _datasource.cancelSubscription();
}
