class SubscriptionCheckout {
  const SubscriptionCheckout({
    required this.checkoutUrl,
    required this.isSandboxCheckout,
    required this.plan,
  });

  final String checkoutUrl;
  final bool isSandboxCheckout;
  final String plan;

  factory SubscriptionCheckout.fromMap(Map<String, dynamic> map) {
    return SubscriptionCheckout(
      checkoutUrl: map['checkoutUrl'] as String? ?? '',
      isSandboxCheckout: map['isSandboxCheckout'] as bool? ?? false,
      plan: map['plan'] as String? ?? 'pro',
    );
  }
}
