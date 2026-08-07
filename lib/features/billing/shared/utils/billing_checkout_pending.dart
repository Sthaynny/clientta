/// Marca checkout Stripe em andamento (browser externo) para sync ao retornar ao app.
class BillingCheckoutPending {
  BillingCheckoutPending._();

  static final BillingCheckoutPending instance = BillingCheckoutPending._();

  bool _active = false;

  bool get isActive => _active;

  void mark() => _active = true;

  void clear() => _active = false;
}
