class SubscriptionCheckout {
  const SubscriptionCheckout({
    required this.checkoutUrl,
    required this.isSandboxCheckout,
    required this.plan,
    this.isFreeAccess = false,
  });

  final String checkoutUrl;
  final bool isSandboxCheckout;
  final bool isFreeAccess;
  final String plan;

  factory SubscriptionCheckout.fromMap(Map<String, dynamic> map) {
    return SubscriptionCheckout(
      checkoutUrl: map['checkoutUrl'] as String? ?? '',
      isSandboxCheckout: map['isSandboxCheckout'] as bool? ?? false,
      isFreeAccess: map['isFreeAccess'] as bool? ?? false,
      plan: map['plan'] as String? ?? 'pro',
    );
  }
}
