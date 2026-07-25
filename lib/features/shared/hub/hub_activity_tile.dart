import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';
import 'package:ufersa_hub/features/activities/domain/models/activity_entry.dart';
import 'package:ufersa_hub/features/shared/hub/hub_activity_kind_style.dart';
import 'package:ufersa_hub/features/shared/hub/hub_surface.dart';

class HubActivityTile extends StatelessWidget {
  const HubActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.done,
    required this.onChanged,
    this.onTap,
    this.onDelete,
  });

  final String title;
  final String subtitle;
  final ActivityKind kind;
  final bool done;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final style = HubActivityKindStyle.forKind(kind);

    return HubSurface(
      margin: EdgeInsets.only(bottom: DSSpacing.sm.value),
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: DSSpacing.sm.value,
        vertical: DSSpacing.xs.value,
      ),
      child: Semantics(
        label: '$title, $subtitle',
        checked: done,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Checkbox(
                value: done,
                onChanged: onChanged,
                activeColor: HubColors.seed,
                checkColor: Colors.white,
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: DSSpacing.xs.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _KindChip(label: style.label, color: style.color),
                      DSSpacing.sm.x,
                      Expanded(
                        child: DSBodyText(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                          color: HubColors.ink,
                          decoration:
                              done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                  DSSpacing.xxs.y,
                  DSCaptionText(
                    subtitle,
                    color: HubColors.inkMuted,
                  ),
                ],
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(
              tooltip: deleteString,
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 20),
              color: HubColors.error,
            ),
        ],
        ),
      ),
    );
  }
}

class _KindChip extends StatelessWidget {
  const _KindChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(DSSpacing.xs.value),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.xs.value,
          vertical: 2,
        ),
        child: DSCaptionSmallText(
          label,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
