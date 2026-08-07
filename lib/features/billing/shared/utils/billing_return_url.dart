import 'package:flutter/foundation.dart';

/// Host HTTPS usado como fallback web e para universal links.
const billingReturnWebHost = 'clientta.app';

/// Scheme customizado para retorno nativo após Checkout Stripe.
const billingReturnAppScheme = 'clientta';

String buildBillingReturnUrl() {
  if (kIsWeb) {
    final base = Uri.base;
    if (base.host.isNotEmpty &&
        base.scheme != 'data' &&
        base.scheme != 'file') {
      return Uri(
        scheme: base.scheme,
        host: base.host,
        port: base.hasPort ? base.port : null,
        path: '/plano',
        queryParameters: {'billing': 'return'},
      ).toString();
    }
    return 'https://$billingReturnWebHost/plano?billing=return';
  }

  return Uri(
    scheme: billingReturnAppScheme,
    host: 'plano',
    queryParameters: {'billing': 'return'},
  ).toString();
}

bool isBillingReturn(Uri uri) {
  return uri.queryParameters['billing'] == 'return' ||
      uri.queryParameters['billing'] == 'success';
}

bool isBillingCheckoutDeepLink(Uri uri) {
  final billing = uri.queryParameters['billing'];
  if (billing != 'success' && billing != 'return' && billing != 'cancel') {
    return false;
  }

  if (uri.scheme == billingReturnAppScheme && uri.host == 'plano') {
    return true;
  }

  if (uri.scheme == 'https' && uri.host == billingReturnWebHost) {
    return uri.path == '/plano' || uri.path.startsWith('/plano/');
  }

  return false;
}
