import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';

class HubSectionHeader extends StatelessWidget {
  const HubSectionHeader({
    super.key,
    required this.title,
    this.count,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final int? count;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: DSSpacing.sm.value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: DSHeadlineSmallText(
                    title,
                    color: HubColors.ink,
                  ),
                ),
                if (count != null) ...[
                  DSSpacing.xs.x,
                  _CountBadge(count: count!),
                ],
              ],
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: HubColors.seed,
                padding: EdgeInsets.symmetric(horizontal: DSSpacing.sm.value),
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: HubColors.successTint,
        borderRadius: BorderRadius.circular(DSSpacing.xs.value),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.xs.value,
          vertical: DSSpacing.xxs.value,
        ),
        child: DSCaptionText(
          '$count',
          fontWeight: FontWeight.w600,
          color: HubColors.seed,
        ),
      ),
    );
  }
}
