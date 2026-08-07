import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';

class HubWeekdayChips extends StatelessWidget {
  const HubWeekdayChips({
    super.key,
    required this.selectedWeekdays,
    required this.onChanged,
    this.enabled = true,
  });

  final Set<int> selectedWeekdays;
  final ValueChanged<Set<int>> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: DSSpacing.xs.value,
      runSpacing: DSSpacing.xs.value,
      children: List.generate(weekdayShortLabels.length, (index) {
        final weekday = index + 1;
        final isSelected = selectedWeekdays.contains(weekday);
        return FilterChip(
          label: Text(weekdayShortLabels[index]),
          selected: isSelected,
          showCheckmark: false,
          onSelected:
              enabled
                  ? (selected) {
                    final next = Set<int>.from(selectedWeekdays);
                    if (selected) {
                      next.add(weekday);
                    } else {
                      next.remove(weekday);
                    }
                    onChanged(next);
                  }
                  : null,
          selectedColor: HubColors.seed.withValues(alpha: 0.14),
          checkmarkColor: HubColors.seed,
          labelStyle: TextStyle(
            color: isSelected ? HubColors.seed : HubColors.inkMuted,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          side: BorderSide(
            color: isSelected ? HubColors.seed : HubColors.border,
          ),
        );
      }),
    );
  }
}
