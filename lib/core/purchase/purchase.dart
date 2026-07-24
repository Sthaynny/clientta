import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

late final Stream<List<PurchaseDetails>> purchaseUpdated;
final StreamController<void> updateSignature = StreamController.broadcast();
var activitedSignature = false;

void handlePurchaseUpdates({
  required List<PurchaseDetails> purchases,
  required InAppPurchase inAppPurchase,
  void Function()? onSuccess,
  void Function()? onError,
}) {
  for (final PurchaseDetails purchase in purchases) {
    if (purchase.status == PurchaseStatus.purchased) {
      // 🔒 Aqui você pode liberar os recursos pagos
      onSuccess?.call();

      // Importante: reconhecer a compra
      inAppPurchase.completePurchase(purchase);
    } else if (purchase.status == PurchaseStatus.error) {
      onError?.call();
    }
  }
}
