enum SubscriptionStatus {
  active,
  trialing,
  pastDue,
  canceled,
  inactive,
}

enum SubscriptionPlan {
  free,
  pro,
}

class UserSubscription {
  const UserSubscription({
    required this.status,
    required this.plan,
    this.accessEndsAt,
  });

  final SubscriptionStatus status;
  final SubscriptionPlan plan;
  final DateTime? accessEndsAt;

  bool get allowsOperationalAccess {
    if (status == SubscriptionStatus.active ||
        status == SubscriptionStatus.trialing) {
      return true;
    }
    if (accessEndsAt != null && DateTime.now().isBefore(accessEndsAt!)) {
      return true;
    }
    return false;
  }

  factory UserSubscription.fromMap(Map<String, dynamic>? map) {
    if (map == null) return UserSubscription.inactive;
    return UserSubscription(
      status: _statusFromString(map['status'] as String?),
      plan: _planFromString(map['plan'] as String?),
      accessEndsAt:
          map['accessEndsAt'] != null
              ? DateTime.tryParse(map['accessEndsAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'status': status.name,
    'plan': plan.name,
    if (accessEndsAt != null) 'accessEndsAt': accessEndsAt!.toIso8601String(),
  };

  static const inactive = UserSubscription(
    status: SubscriptionStatus.inactive,
    plan: SubscriptionPlan.free,
  );

  static SubscriptionStatus _statusFromString(String? value) {
    return SubscriptionStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => SubscriptionStatus.inactive,
    );
  }

  static SubscriptionPlan _planFromString(String? value) {
    return SubscriptionPlan.values.firstWhere(
      (p) => p.name == value,
      orElse: () => SubscriptionPlan.free,
    );
  }
}
