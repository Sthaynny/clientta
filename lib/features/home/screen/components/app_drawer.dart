import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/purchase/purchase.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/app_mission.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/features/home/screen/components/button_signature.dart';
import 'package:ufersa_hub/features/shared/components/app_icon.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: DSColors.secundary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const AppIcon(scale: 30),
                    DSSpacing.xs.x,
                    Expanded(
                      child: DSHeadlineLargeText(
                        AppMission.name,
                        color: DSColors.white,
                      ),
                    ),
                  ],
                ),
                DSSpacing.xs.y,
                DSBodyText(AppMission.tagline, maxLines: 3),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(homeTodayString),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRouters.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_week_outlined),
            title: Text(myScheduleString),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRouters.classes);
            },
          ),
          ListTile(
            leading: const Icon(Icons.checklist_outlined),
            title: Text(myActivitiesString),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRouters.activities);
            },
          ),
          if (!activitedSignature)
            Padding(
              padding: const EdgeInsets.all(DSSpacing.md),
              child: const ButtonSignature(),
            ),
        ],
      ),
    );
  }
}
