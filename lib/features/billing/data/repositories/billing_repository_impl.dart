import 'package:clientta/features/billing/data/datasources/firebase_billing_datasource.dart';
import 'package:clientta/features/billing/domain/entities/subscription_checkout.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';

class BillingRepositoryImpl implements BillingRepository {
  BillingRepositoryImpl(this._datasource);

  final FirebaseBillingDatasource _datasource;

  @override
  Future<Map<String, dynamic>> getPlanPricing() =>
      _datasource.getPlanPricing();

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
  Future<void> cancelSubscription() => _datasource.cancelSubscription();
}
