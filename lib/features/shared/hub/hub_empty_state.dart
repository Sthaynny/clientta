import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';

class HubEmptyState extends StatelessWidget {
  const HubEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(DSSpacing.xl.value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: HubColors.successTint,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(DSSpacing.lg.value),
                child: Icon(icon, size: 40, color: HubColors.seed),
              ),
            ),
            DSSpacing.lg.y,
            DSHeadlineSmallText(
              title,
              textAlign: TextAlign.center,
              color: HubColors.ink,
            ),
            DSSpacing.sm.y,
            DSCaptionText(
              message,
              textAlign: TextAlign.center,
              height: 1.45,
              color: HubColors.inkMuted,
            ),
            if (actionLabel != null && onAction != null) ...[
              DSSpacing.lg.y,
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: DSSpacing.lg.value,
                    vertical: DSSpacing.md.value,
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
