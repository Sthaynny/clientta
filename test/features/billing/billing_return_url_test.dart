import 'package:clientta/features/billing/shared/utils/billing_return_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildBillingReturnUrl', () {
    test('uses custom scheme on native', () {
      final url = buildBillingReturnUrl();
      final uri = Uri.parse(url);
      expect(uri.scheme, billingReturnAppScheme);
      expect(uri.host, 'plano');
      expect(uri.queryParameters['billing'], 'return');
    });
  });

  group('isBillingCheckoutDeepLink', () {
    test('accepts custom scheme with billing success', () {
      expect(
        isBillingCheckoutDeepLink(
          Uri.parse('clientta://plano?billing=success'),
        ),
        isTrue,
      );
    });

    test('accepts https clientta.app plano path', () {
      expect(
        isBillingCheckoutDeepLink(
          Uri.parse('https://clientta.app/plano?billing=success'),
        ),
        isTrue,
      );
    });

    test('rejects unrelated urls', () {
      expect(
        isBillingCheckoutDeepLink(Uri.parse('https://clientta.app/')),
        isFalse,
      );
    });
  });
}
