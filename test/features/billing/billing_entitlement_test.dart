import 'package:clientta/features/billing/domain/entities/billing_entitlement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BillingEntitlement', () {
    test('parses free access cache from firestore map', () {
      final entitlement = BillingEntitlement.fromMap({
        'type': 'free',
        'baseMonthlyPriceCents': 2990,
        'effectiveMonthlyPriceCents': 0,
        'note': 'Parceiro',
        'syncedAt': '2026-08-07T00:00:00.000Z',
      });

      expect(entitlement.type, BillingEntitlementType.free);
      expect(entitlement.hasFreeAccess, isTrue);
      expect(entitlement.effectiveMonthlyPriceCents, 0);
      expect(entitlement.note, 'Parceiro');
    });

    test('parses discount cache from firestore map', () {
      final entitlement = BillingEntitlement.fromMap({
        'type': 'discount',
        'percentOff': 50,
        'baseMonthlyPriceCents': 2990,
        'effectiveMonthlyPriceCents': 1495,
      });

      expect(entitlement.type, BillingEntitlementType.discount);
      expect(entitlement.hasDiscount, isTrue);
      expect(entitlement.percentOff, 50);
    });
  });
}
