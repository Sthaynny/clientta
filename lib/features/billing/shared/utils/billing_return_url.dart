String buildBillingReturnUrl() {
  // Em web, o host atual; em mobile, deep link ou URL configurada no deploy.
  return 'https://clientta.app/plano?billing=return';
}

bool isBillingReturn(Uri uri) {
  return uri.queryParameters['billing'] == 'return' ||
      uri.queryParameters['billing'] == 'success';
}
