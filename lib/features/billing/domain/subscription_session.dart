import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';

/// Estado reativo da assinatura Pro lido de Firestore.
class SubscriptionSession extends ChangeNotifier {
  SubscriptionSession({required BillingRepository billingRepository})
    : _billingRepository = billingRepository;

  final BillingRepository _billingRepository;
  StreamSubscription<UserSubscription>? _watchSub;
  UserSubscription _subscription = UserSubscription.inactive;

  UserSubscription get subscription => _subscription;

  void start() {
    _watchSub?.cancel();
    _watchSub = _billingRepository.watchSubscription().listen((next) {
      if (_subscription == next) return;
      _subscription = next;
      notifyListeners();
    });
  }

  void reset() {
    _watchSub?.cancel();
    _watchSub = null;
    _subscription = UserSubscription.inactive;
    notifyListeners();
  }

  Future<void> refreshFromStripe() async {
    try {
      final updated = await _billingRepository.syncSubscriptionStatus();
      if (_subscription != updated) {
        _subscription = updated;
        notifyListeners();
      }
    } catch (_) {
      // Firestore watch ou retry posterior atualiza o estado.
    }
  }

  @override
  void dispose() {
    _watchSub?.cancel();
    super.dispose();
  }
}
