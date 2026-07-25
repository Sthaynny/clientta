import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';

/// Multi-select weekday row (1 = Monday … 7 = Sunday) for class schedules.
class HubWeekdayChips extends StatelessWidget {
  const HubWeekdayChips({
    super.key,
    required this.label,
    required this.selectedWeekdays,
    required this.onChanged,
  });

  final String label;
  final Set<int> selectedWeekdays;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
      ).applyDefaults(inputTheme),
      child: Wrap(
        spacing: DSSpacing.sm.value,
        runSpacing: DSSpacing.sm.value,
        children: List.generate(7, (index) {
          final weekday = index + 1;
          final selected = selectedWeekdays.contains(weekday);
          return FilterChip(
            label: Text(
              weekdayLabels[index],
              style: theme.textTheme.bodySmall?.copyWith(
                color: selected ? HubColors.seed : HubColors.ink,
              ),
            ),
            selected: selected,
            showCheckmark: false,
            selectedColor: HubColors.successTint,
            side: BorderSide(
              color: selected ? HubColors.seed : HubColors.border,
            ),
            onSelected: (value) {
              final next = Set<int>.from(selectedWeekdays);
              if (value) {
                next.add(weekday);
              } else {
                next.remove(weekday);
              }
              onChanged(next);
            },
          );
        }),
      ),
    );
  }
}
