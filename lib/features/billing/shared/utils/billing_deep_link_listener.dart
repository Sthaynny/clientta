import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:clientta/core/router/app_navigator.dart';

/// Escuta deep links de retorno do Checkout Stripe (`billing=success`).
class BillingDeepLinkListener {
  BillingDeepLinkListener({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;
  StreamSubscription<Uri>? _subscription;

  Future<void> start() async {
    final initial = await _appLinks.getInitialLink();
    if (initial != null) {
      AppNavigator.handleBillingDeepLink(initial);
    }

    _subscription ??= _appLinks.uriLinkStream.listen(AppNavigator.handleBillingDeepLink);
  }

  void dispose() {
    unawaited(_subscription?.cancel());
    _subscription = null;
  }
}
