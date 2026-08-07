import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/shared/hub/hub_surface.dart';

/// Faixa contextual no topo de listas — reduz lacunas e orienta a tarefa da tela.
class HubScreenIntro extends StatelessWidget {
  const HubScreenIntro({
    super.key,
    required this.icon,
    required this.message,
    this.iconColor = HubColors.schedule,
    this.tint = HubColors.canvas,
  });

  final IconData icon;
  final String message;
  final Color iconColor;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      padding: EdgeInsets.all(DSSpacing.md.value),
      tint: tint,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(DSSpacing.xs.value),
            ),
            child: Padding(
              padding: EdgeInsets.all(DSSpacing.xs.value),
              child: Icon(icon, size: 20, color: iconColor),
            ),
          ),
          DSSpacing.sm.x,
          Expanded(
            child: DSBodyText(
              message,
              color: HubColors.inkMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
