import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/shared/hub/hub_surface.dart';

/// Destaques curtos em telas de auth — reduz lacuna visual e comunica valor.
class HubAuthHighlights extends StatelessWidget {
  const HubAuthHighlights({super.key, required this.items});

  final List<HubAuthHighlight> items;

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      tint: HubColors.canvas,
      padding: EdgeInsets.symmetric(
        horizontal: DSSpacing.md.value,
        vertical: DSSpacing.sm.value,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _HubAuthHighlightRow(item: items[i]),
            if (i < items.length - 1) DSSpacing.sm.y,
          ],
        ],
      ),
    );
  }
}

class HubAuthHighlight {
  const HubAuthHighlight({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _HubAuthHighlightRow extends StatelessWidget {
  const _HubAuthHighlightRow({required this.item});

  final HubAuthHighlight item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: HubColors.seed.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(DSSpacing.xs.value),
          ),
          child: Padding(
            padding: EdgeInsets.all(DSSpacing.xxs.value),
            child: Icon(item.icon, size: 16, color: HubColors.seed),
          ),
        ),
        DSSpacing.sm.x,
        Expanded(
          child: DSBodyText(
            item.label,
            color: HubColors.inkMuted,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
