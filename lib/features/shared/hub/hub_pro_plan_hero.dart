import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/theme/hub_theme.dart';
import 'package:clientta/features/billing/domain/entities/plan_pricing_catalog.dart';
import 'package:clientta/features/shared/hub/hub_shimmer.dart';

/// Cabeçalho visual do Clientta Pro — gradiente, preço e CTA integrados.
class HubProPlanHero extends StatelessWidget {
  const HubProPlanHero({
    super.key,
    required this.price,
    this.showPrice = true,
    this.isProActive = false,
    this.statusLabel,
    this.percentOff,
    this.basePriceCents,
    this.action,
  });

  final String price;
  final bool showPrice;
  final bool isProActive;
  final String? statusLabel;
  final int? percentOff;
  final int? basePriceCents;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = percentOff != null && percentOff! > 0 && showPrice;

    return Semantics(
      container: true,
      label: '$planProTitleString. $planProPitchString',
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DSSpacing.md.value),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [HubColors.seedDark, HubColors.seed],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0F4535),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(DSSpacing.lg.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _ProBadge(isActive: isProActive),
                  if (statusLabel != null) ...[
                    DSSpacing.sm.x,
                    Flexible(
                      child: _StatusChip(label: statusLabel!),
                    ),
                  ],
                ],
              ),
              DSSpacing.md.y,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(DSSpacing.sm.value),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  DSSpacing.md.x,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DSHeadlineSmallText(
                          planProTitleString,
                          color: Colors.white,
                        ),
                        DSSpacing.xxs.y,
                        DSBodyText(
                          planProPitchString,
                          color: Colors.white.withValues(alpha: 0.88),
                          height: 1.4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (showPrice) ...[
                DSSpacing.lg.y,
                if (hasDiscount) ...[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(DSSpacing.xs.value),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: DSSpacing.sm.value,
                        vertical: DSSpacing.xxs.value,
                      ),
                      child: DSCaptionText(
                        planDiscountAppliedString(percentOff!),
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  DSSpacing.sm.y,
                ],
                DSHeadlineLargeText(
                  price,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                if (hasDiscount && basePriceCents != null) ...[
                  DSSpacing.xxs.y,
                  DSCaptionText(
                    '$planBasePriceLabelString: '
                    '${PlanPricingCatalog.formatBrlMonthly(basePriceCents!)}',
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ],
                DSSpacing.xs.y,
                DSCaptionSmallText(
                  planProPriceHintString,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ] else if (isProActive) ...[
                DSSpacing.lg.y,
                Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 20,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                    DSSpacing.xs.x,
                    Expanded(
                      child: DSCaptionText(
                        planProActiveBenefitsHintString,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
              if (action != null) ...[
                DSSpacing.lg.y,
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isActive ? 0.22 : 0.14),
        borderRadius: BorderRadius.circular(DSSpacing.xs.value),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.sm.value,
          vertical: DSSpacing.xxs.value,
        ),
        child: DSCaptionSmallText(
          planProBadgeString,
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(DSSpacing.xs.value),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.sm.value,
          vertical: DSSpacing.xxs.value,
        ),
        child: DSCaptionSmallText(
          label,
          color: Colors.white.withValues(alpha: 0.95),
          fontWeight: FontWeight.w600,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// CTA claro sobre o gradiente do hero Pro.
class HubProHeroButton extends StatelessWidget {
  const HubProHeroButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: label,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(HubTheme.minTouchTarget),
            backgroundColor: Colors.white,
            foregroundColor: HubColors.seed,
            disabledBackgroundColor: Colors.white.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DSSpacing.sm.value),
            ),
          ),
          child: isLoading
              ? HubShimmer(
                  child: HubShimmerBox(
                    height: 20,
                    width: 120,
                    color: HubColors.seed.withValues(alpha: 0.2),
                    radius: DSSpacing.xs.value,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}
