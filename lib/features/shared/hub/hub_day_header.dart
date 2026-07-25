import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/strings/app_mission.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';
import 'package:ufersa_hub/features/shared/hub/hub_surface.dart';

class HubDayHeader extends StatelessWidget {
  const HubDayHeader({
    super.key,
    required this.weekdayLabel,
    required this.dateLabel,
  });

  final String weekdayLabel;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      tint: HubColors.seedDark,
      showBorder: false,
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
    );
  }
}
