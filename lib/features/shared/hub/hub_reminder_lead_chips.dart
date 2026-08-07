import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_settings.dart';

class HubReminderLeadChips extends StatelessWidget {
  const HubReminderLeadChips({
    super.key,
    required this.selectedMinutes,
    required this.onChanged,
    this.enabled = true,
  });

  final int selectedMinutes;
  final ValueChanged<int> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: DSSpacing.xs.value,
      runSpacing: DSSpacing.xs.value,
      children:
          AppointmentReminderSettings.supportedLeadMinutes.map((minutes) {
            final isSelected = selectedMinutes == minutes;
            return FilterChip(
              label: Text(reminderLeadMinutesLabel(minutes)),
              selected: isSelected,
              showCheckmark: false,
              onSelected:
                  enabled
                      ? (_) => onChanged(minutes)
                      : null,
              selectedColor: HubColors.seed.withValues(alpha: 0.14),
              labelStyle: TextStyle(
                color: isSelected ? HubColors.seed : HubColors.inkMuted,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              side: BorderSide(
                color: isSelected ? HubColors.seed : HubColors.border,
              ),
            );
          }).toList(),
    );
  }
}
