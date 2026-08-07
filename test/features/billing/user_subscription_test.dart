import 'package:clientta/features/billing/domain/entities/user_subscription.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserSubscription', () {
    test('allows operational access for active pro', () {
      const subscription = UserSubscription(
        status: SubscriptionStatus.active,
        plan: SubscriptionPlan.pro,
      );

      expect(subscription.allowsOperationalAccess, isTrue);
    });

    test('allows grace period until accessEndsAt', () {
      final subscription = UserSubscription(
        status: SubscriptionStatus.canceled,
        plan: SubscriptionPlan.pro,
        accessEndsAt: DateTime.now().add(const Duration(days: 7)),
      );

      expect(subscription.allowsOperationalAccess, isTrue);
    });

    test('parses firestore map', () {
      final subscription = UserSubscription.fromMap({
        'status': 'active',
        'plan': 'pro',
        'accessEndsAt': '2026-09-07T00:00:00.000Z',
      });

      expect(subscription.status, SubscriptionStatus.active);
      expect(subscription.plan, SubscriptionPlan.pro);
      expect(subscription.accessEndsAt, isNotNull);
    });
  });
}
