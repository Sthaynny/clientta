import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:university_hub/core/strings/app_mission.dart';
import 'package:university_hub/core/strings/daily_strings.dart';
import 'package:university_hub/core/theme/hub_colors.dart';

class HubDayHeader extends StatelessWidget {
  const HubDayHeader({
    super.key,
    required this.weekdayLabel,
    required this.dateLabel,
    this.classesTodayCount,
    this.activitiesTodayCount,
  });

  final String weekdayLabel;
  final String dateLabel;
  final int? classesTodayCount;
  final int? activitiesTodayCount;

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
            Text(
              dateLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.03,
                height: 1.15,
              ),
            ),
            if (classesTodayCount != null || activitiesTodayCount != null) ...[
              DSSpacing.md.y,
              Wrap(
                spacing: DSSpacing.sm.value,
                runSpacing: DSSpacing.xs.value,
                children: [
                  if (classesTodayCount != null)
                    _StatChip(
                      icon: Icons.schedule_outlined,
                      label: homeDayStatClasses(classesTodayCount!),
                    ),
                  if (activitiesTodayCount != null)
                    _StatChip(
                      icon: Icons.task_alt_outlined,
                      label: homeDayStatActivities(activitiesTodayCount!),
                    ),
                ],
              ),
            ],
            DSSpacing.sm.y,
            DSCaptionText(
              AppMission.purposeSummary,
              color: Colors.white.withValues(alpha: 0.88),
              height: 1.4,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
