import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:university_hub/core/theme/hub_colors.dart';
import 'package:university_hub/features/shared/hub/hub_surface.dart';

class HubHomeQuickActions extends StatelessWidget {
  const HubHomeQuickActions({
    super.key,
    required this.addClassLabel,
    required this.addActivityLabel,
    required this.onAddClass,
    required this.onAddActivity,
  });

  final String addClassLabel;
  final String addActivityLabel;
  final VoidCallback onAddClass;
  final VoidCallback onAddActivity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.schedule_outlined,
            label: addClassLabel,
            accent: HubColors.schedule,
            accentMuted: HubColors.scheduleMuted,
            onTap: onAddClass,
          ),
        ),
        DSSpacing.sm.x,
        Expanded(
          child: _QuickAction(
            icon: Icons.task_alt_outlined,
            label: addActivityLabel,
            accent: HubColors.seed,
            accentMuted: HubColors.successTint,
            onTap: onAddActivity,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.accent,
    required this.accentMuted,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final Color accentMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: DSSpacing.md.value,
        vertical: DSSpacing.md.value,
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: accentMuted,
              borderRadius: BorderRadius.circular(DSSpacing.xs.value),
            ),
            child: Padding(
              padding: EdgeInsets.all(DSSpacing.xs.value),
              child: Icon(icon, size: 22, color: accent),
            ),
          ),
          DSSpacing.sm.x,
          Expanded(
            child: DSBodyText(
              label,
              fontWeight: FontWeight.w600,
              color: HubColors.ink,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
