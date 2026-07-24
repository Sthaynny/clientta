import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ufersa_hub/core/purchase/app_signature.dart';
import 'package:ufersa_hub/core/purchase/purchase.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/app_mission.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<List<PurchaseDetails>> _subscription;
  late final StreamSubscription<void> subscriptionSignature;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppMission.name,
      initialRoute: AppRouters.home.path,
      routes: routes,
    );
  }

  @override
  void initState() {
    super.initState();
    purchaseUpdated = InAppPurchase.instance.purchaseStream;
    subscriptionSignature = updateSignature.stream.listen((event) {
      setState(() {});
    });

    varifyAssingature();
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // handle error here.
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    subscriptionSignature.cancel();
    super.dispose();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    // ignore: avoid_function_literals_in_foreach_calls
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final bool valid = _verifyPurchase(purchaseDetails);
        if (valid) {
          activitedSignature = true;
          updateSignature.add(null);
        } else {
          activitedSignature = false;
        }
        updateSignature.add(null);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    });
  }

  bool _verifyPurchase(PurchaseDetails purchaseDetails) {
    if (AppSignature.values.any(
      (element) => element.name == purchaseDetails.productID,
    )) {
      return true;
    }
    return false;
  }

  Future<void> varifyAssingature() async {
    final inApp = FlutterInappPurchase.instance;
    await FlutterInappPurchase.instance.initialize();
    final response = await inApp.checkSubscribed(
      sku: AppSignature.noAds.name.camelToSnakeCase,
    );

    if (response) {
      activitedSignature = true;
      updateSignature.add(null);
    }
  }
}
