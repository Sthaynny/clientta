import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/config/app_config.dart';
import 'package:ufersa_hub/core/strings/app_mission.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';

class HubOfflineBanner extends StatelessWidget {
  const HubOfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.isUniversityMode) {
      return const SizedBox.shrink();
    }

    return Material(
      color: HubColors.scheduleMuted,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.md.value,
          vertical: DSSpacing.sm.value,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.phonelink_lock_outlined,
              size: 20,
              color: HubColors.schedule,
            ),
            DSSpacing.sm.x,
            Expanded(
              child: Text(
                AppMission.stripMessage,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: HubColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
