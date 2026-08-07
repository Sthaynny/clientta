import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/app_mission.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/shared/components/app_icon.dart';
import 'package:clientta/features/shared/hub/hub_nav_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: HubColors.seedDark,
              padding: EdgeInsets.fromLTRB(
                DSSpacing.lg.value,
                DSSpacing.lg.value,
                DSSpacing.lg.value,
                DSSpacing.md.value,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppIcon.hub(size: 44),
                      DSSpacing.sm.x,
                      Expanded(
                        child: Text(
                          AppMission.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.02,
                          ),
                        ),
                      ),
                    ],
                  ),
                  DSSpacing.sm.y,
                  Text(
                    AppMission.tagline,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: DSSpacing.sm.value),
                children: [
                  HubNavTile(
                    icon: Icons.today_outlined,
                    label: homeTodayString,
                    route: AppRouters.home,
                    isSelected: currentRoute == AppRouters.home.path,
                  ),
                  HubNavTile(
                    icon: Icons.event_note_outlined,
                    label: myAgendaString,
                    route: AppRouters.agendas,
                    isSelected: currentRoute == AppRouters.agendas.path,
                  ),
                  HubNavTile(
                    icon: Icons.workspace_premium_outlined,
                    label: planSettingsTitleString,
                    route: AppRouters.planSettings,
                    isSelected: currentRoute == AppRouters.planSettings.path,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
