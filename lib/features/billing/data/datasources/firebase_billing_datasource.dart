import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import 'package:clientta/features/billing/domain/entities/subscription_checkout.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';

class FirebaseBillingDatasource {
  FirebaseBillingDatasource({FirebaseFunctions? functions})
    : _functions =
          functions ??
          FirebaseFunctions.instanceFor(region: 'southamerica-east1');

  final FirebaseFunctions _functions;

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

  Future<Map<String, dynamic>> getPlanPricing() async {
    final response = await _callFunction('getPlanPricing', {});
    return Map<String, dynamic>.from(response);
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

  Future<void> cancelSubscription() async {
    await _callFunction('cancelSubscription', {});
  }
}
