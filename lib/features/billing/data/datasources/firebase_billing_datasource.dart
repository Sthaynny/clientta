import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:clientta/features/billing/domain/entities/billing_entitlement.dart';
import 'package:clientta/features/billing/domain/entities/subscription_checkout.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';

class FirebaseBillingDatasource {
  FirebaseBillingDatasource({
    FirebaseFunctions? functions,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _functions =
           functions ??
           FirebaseFunctions.instanceFor(region: 'southamerica-east1'),
       _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFunctions _functions;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<Map<String, dynamic>> _callFunction(
    String name,
    Map<String, dynamic> data,
  ) async {
    try {
      final callable = _functions.httpsCallable(name);
      final result = await callable.call<Map<String, dynamic>>(data);
      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (error) {
      if (kDebugMode) {
        debugPrint(
          'Billing callable error: code=${error.code} message=${error.message}',
        );
      }
      throw _mapFunctionsException(error);
    }
  }

  Exception _mapFunctionsException(FirebaseFunctionsException error) {
    final code = error.code;
    if (code == 'internal' ||
        code == 'not-found' ||
        code == 'unavailable' ||
        code == 'unknown') {
      return Exception('Cobrança ainda não está configurada no servidor.');
    }

    if (code == 'failed-precondition') {
      final message = error.message?.trim();
      if (message != null && message.isNotEmpty) {
        return Exception(message);
      }
    }

    return Exception(error.message ?? 'Falha na cobrança.');
  }

  String? get _uid => _auth.currentUser?.uid;

  Future<Map<String, dynamic>> getPlanPricing() async {
    final response = await _callFunction('getPlanPricing', {});
    return Map<String, dynamic>.from(response);
  }

  Future<BillingEntitlement> syncEntitlements() async {
    final response = await _callFunction('syncEntitlements', {});
    final entitlementRaw = response['billingEntitlement'];
    if (entitlementRaw is Map) {
      return BillingEntitlement.fromMap(
        Map<String, dynamic>.from(entitlementRaw),
      );
    }
    return BillingEntitlement.none;
  }

  Future<UserSubscription> getSubscription() async {
    final uid = _uid;
    if (uid == null) return UserSubscription.inactive;

    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null) return UserSubscription.inactive;

    final subscriptionRaw = data['subscription'];
    if (subscriptionRaw is! Map) return UserSubscription.inactive;

    return UserSubscription.fromMap(
      Map<String, dynamic>.from(subscriptionRaw),
    );
  }

  Stream<UserSubscription> watchSubscription() {
    final uid = _uid;
    if (uid == null) {
      return Stream.value(UserSubscription.inactive);
    }

    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      final subscriptionRaw = snapshot.data()?['subscription'];
      if (subscriptionRaw is! Map) return UserSubscription.inactive;
      return UserSubscription.fromMap(
        Map<String, dynamic>.from(subscriptionRaw),
      );
    });
  }

  Future<SubscriptionCheckout> createSubscription({
    required String planId,
    required String returnUrl,
  }) async {
    final response = await _callFunction('createSubscription', {
      'plan': planId,
      'returnUrl': returnUrl,
    });
    return SubscriptionCheckout.fromMap(response);
  }

  Future<UserSubscription> syncSubscriptionStatus() async {
    final response = await _callFunction('syncSubscriptionStatus', {});
    final subscriptionRaw = response['subscription'];
    if (subscriptionRaw is Map) {
      return UserSubscription.fromMap(
        Map<String, dynamic>.from(subscriptionRaw),
      );
    }
    return UserSubscription.inactive;
  }

  Future<UserSubscription> completeSandboxSubscription() async {
    final response = await _callFunction('completeSandboxSubscription', {});
    final subscriptionRaw = response['subscription'];
    if (subscriptionRaw is Map) {
      return UserSubscription.fromMap(
        Map<String, dynamic>.from(subscriptionRaw),
      );
    }
    return UserSubscription.inactive;
  }

  Future<UserSubscription> cancelSubscription() async {
    final response = await _callFunction('cancelSubscription', {});
    final subscriptionRaw = response['subscription'];
    if (subscriptionRaw is Map) {
      return UserSubscription.fromMap(
        Map<String, dynamic>.from(subscriptionRaw),
      );
    }
    return getSubscription();
  }
}
