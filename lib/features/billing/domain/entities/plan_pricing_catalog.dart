/// Catálogo local de preços — espelha `functions/pricing.js`.
/// Usado como fallback quando a callable `getPlanPricing` não está disponível.
class PlanPricingCatalog {
  PlanPricingCatalog._();

  static const int proMonthlyPriceCents = 2990;

  static String formatBrlMonthly(int cents) {
    final value = (cents / 100).toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $value/mês';
  }

  static Map<String, dynamic> toMap() => {
    'pro': {
      'id': 'pro',
      'name': 'Clientta Pro',
      'price': formatBrlMonthly(proMonthlyPriceCents),
      'monthlyPriceCents': proMonthlyPriceCents,
      'enabled': true,
    },
  };
}
