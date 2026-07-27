import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:university_hub/core/schedule/academic_night_shift.dart';
import 'package:university_hub/core/strings/daily_strings.dart';
import 'package:university_hub/core/theme/hub_colors.dart';

/// Quick-fill chips for common night-shift blocks and single periods.
class HubNightShiftPresets extends StatelessWidget {
  const HubNightShiftPresets({
    super.key,
    required this.onApply,
    this.initiallyExpanded = false,
  });

  final void Function(String startTime, String endTime) onApply;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.only(bottom: DSSpacing.xs.value),
        title: DSCaptionText(
          classNightShiftPresetsTitleString,
          color: HubColors.inkMuted,
        ),
        iconColor: HubColors.inkMuted,
        collapsedIconColor: HubColors.inkMuted,
        children: [
          Wrap(
            spacing: DSSpacing.sm.value,
            runSpacing: DSSpacing.sm.value,
            children: [
              for (final block in academicNightBlocks)
                ActionChip(
                  label: Text(
                    '${block.label} · ${block.startTime}–${block.endTime}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: HubColors.ink,
                    ),
                  ),
                  side: const BorderSide(color: HubColors.border),
                  onPressed: () => onApply(block.startTime, block.endTime),
                ),
              for (final period in academicNightPeriods)
                ActionChip(
                  label: Text(
                    '${period.shortLabel} · ${period.startTime}–${period.endTime}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: HubColors.ink,
                    ),
                  ),
                  side: const BorderSide(color: HubColors.border),
                  onPressed: () => onApply(period.startTime, period.endTime),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
