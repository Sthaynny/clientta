import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';

class HubDayHeader extends StatelessWidget {
  const HubDayHeader({
    super.key,
    required this.weekdayLabel,
    required this.dateLabel,
    this.appointmentsTodayCount,
  });

  final String weekdayLabel;
  final String dateLabel;
  final int? appointmentsTodayCount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DSSpacing.md.value),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [HubColors.seedDark, HubColors.seed],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A0F4535),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Semantics(
        header: true,
        label: '$weekdayLabel, $dateLabel',
        child: Padding(
          padding: EdgeInsets.all(DSSpacing.lg.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DSCaptionText(
                weekdayLabel,
                color: HubColors.onPrimaryMuted,
                fontWeight: FontWeight.w500,
              ),
              DSSpacing.xxs.y,
              DSHeadlineLargeText(
                dateLabel,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
              if (appointmentsTodayCount != null) ...[
                DSSpacing.md.y,
                _StatChip(
                  icon: Icons.event_note_outlined,
                  label: homeDayStatAppointments(appointmentsTodayCount!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(DSSpacing.xs.value),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.sm.value,
          vertical: DSSpacing.xxs.value,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.95)),
            DSSpacing.xxs.x,
            DSCaptionText(
              label,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ],
        ),
      ),
    );
  }
}
