import 'package:clientta/features/billing/domain/entities/plan_pricing_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlanPricingCatalog', () {
    test('toMap returns pro plan with BRL price', () {
      final pricing = PlanPricingCatalog.toMap();
      final pro = pricing['pro'] as Map<String, dynamic>;

      expect(pro['id'], 'pro');
      expect(pro['enabled'], isTrue);
      expect(pro['price'], 'R\$ 29,90/mês');
      expect(pro['monthlyPriceCents'], 2990);
    });

    test('formatBrlMonthly formats cents as BRL monthly string', () {
      expect(PlanPricingCatalog.formatBrlMonthly(2990), 'R\$ 29,90/mês');
    });
  });
}
