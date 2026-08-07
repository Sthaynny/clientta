import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/shared/hub/hub_primary_button.dart';

class HubEmptyState extends StatelessWidget {
  const HubEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.embedded = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Quando true, ocupa só o espaço da seção (ex.: cards na home), não a tela inteira.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final padding = embedded ? DSSpacing.lg.value : DSSpacing.xl.value;
    final content = Semantics(
      container: true,
      label: '$title. $message',
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              embedded ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            ExcludeSemantics(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: HubColors.successTint,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(DSSpacing.lg.value),
                  child: Icon(icon, size: 40, color: HubColors.seed),
                ),
              ),
            ),
            DSSpacing.lg.y,
            Semantics(
              header: true,
              child: DSHeadlineSmallText(
                title,
                textAlign: TextAlign.center,
                color: HubColors.ink,
              ),
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
              HubPrimaryButton(
                label: actionLabel,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );

    if (embedded) return content;
    return Center(child: content);
  }
}
