enum BillingEntitlementType {
  none,
  free,
  discount,
}

class BillingEntitlement {
  const BillingEntitlement({
    required this.type,
    this.percentOff,
    this.baseMonthlyPriceCents,
    this.effectiveMonthlyPriceCents,
    this.note,
    this.syncedAt,
  });

  final BillingEntitlementType type;
  final int? percentOff;
  final int? baseMonthlyPriceCents;
  final int? effectiveMonthlyPriceCents;
  final String? note;
  final DateTime? syncedAt;

  bool get hasFreeAccess => type == BillingEntitlementType.free;

  bool get hasDiscount => type == BillingEntitlementType.discount;

  factory BillingEntitlement.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BillingEntitlement.none;

    return BillingEntitlement(
      type: _typeFromString(map['type'] as String?),
      percentOff: map['percentOff'] as int?,
      baseMonthlyPriceCents: map['baseMonthlyPriceCents'] as int?,
      effectiveMonthlyPriceCents: map['effectiveMonthlyPriceCents'] as int?,
      note: map['note'] as String?,
      syncedAt:
          map['syncedAt'] != null
              ? DateTime.tryParse(map['syncedAt'] as String)
              : null,
    );
  }

  static const none = BillingEntitlement(type: BillingEntitlementType.none);

  static BillingEntitlementType _typeFromString(String? value) {
    return BillingEntitlementType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => BillingEntitlementType.none,
    );
  }
}
