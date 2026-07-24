import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ufersa_hub/core/purchase/app_signature.dart';
import 'package:ufersa_hub/core/purchase/purchase.dart';
import 'package:ufersa_hub/core/strings/strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';

class ButtonSignature extends StatefulWidget {
  const ButtonSignature({super.key});

  @override
  State<ButtonSignature> createState() => _ButtonSignatureState();
}

class _ButtonSignatureState extends State<ButtonSignature> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = [];

  final ValueNotifier<bool> _available = ValueNotifier(false);

  final Set<String> _kIds = {AppSignature.noAds.name.camelToSnakeCase};
  late final StreamSubscription subscription;

  void showSnackBarInfo(String message) {
    context.showSnackBarInfo(message);
  }

  Future<void> _initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      showSnackBarInfo(signatureNotFoundString);
      return;
    }

    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      showSnackBarInfo(signatureNotFoundString);
    } else {
      _available.value = isAvailable;
      _products = response.productDetails;
    }
  }

  @override
  void initState() {
    super.initState();
    _initStoreInfo();
    subscription = _inAppPurchase.purchaseStream.listen((purchases) {
      handlePurchaseUpdates(
        purchases: purchases,
        inAppPurchase: _inAppPurchase,
        onSuccess: () {
          context.showSnackBarSuccess(signatureBuySucessString);
        },
        onError: () {
          context.showSnackBarError(signatureBuyErrorString);
        },
      );
    });
  }

  @override
  void dispose() {
    _available.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _available,
      builder: (context, value, child) {
        return DSPrimaryButton(
          isLoading: !value,
          onPressed: () {
            final PurchaseParam purchaseParam = PurchaseParam(
              productDetails: _products.first,
            );
            _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
          },
          label: useAppNoAdsString,
          backgroundColor: DSColors.primary,
          leadingIcon: Icon(
            DSIcons.favorite_solid.data,
            color: DSColors.secundary,
          ),
        );
      },
    );
  }
}
