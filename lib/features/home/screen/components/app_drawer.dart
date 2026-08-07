import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/app_mission.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/auth/domain/repositories/auth_repository.dart';
import 'package:clientta/features/shared/components/app_icon.dart';
import 'package:clientta/features/shared/hub/hub_legal_footer.dart';
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
                      AppIcon.onDark(size: 44),
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
                padding: EdgeInsets.fromLTRB(
                  DSSpacing.sm.value,
                  DSSpacing.xs.value,
                  DSSpacing.sm.value,
                  DSSpacing.sm.value,
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: DSSpacing.sm.value,
                      vertical: DSSpacing.xxs.value,
                    ),
                    child: DSCaptionText(
                      drawerNavSectionString,
                      color: HubColors.inkMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                    icon: Icons.people_outline_rounded,
                    label: myClientsString,
                    route: AppRouters.clients,
                    isSelected: currentRoute == AppRouters.clients.path,
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
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(
                DSSpacing.sm.value,
                DSSpacing.sm.value,
                DSSpacing.sm.value,
                DSSpacing.xs.value,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: DSSpacing.sm.value,
                      vertical: DSSpacing.xxs.value,
                    ),
                    child: DSCaptionText(
                      legalSectionString,
                      color: HubColors.inkMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const HubLegalLinks(alignment: WrapAlignment.start),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(
                DSSpacing.sm.value,
                DSSpacing.sm.value,
                DSSpacing.sm.value,
                DSSpacing.md.value,
              ),
              child: ListTile(
                leading: Icon(Icons.logout_outlined, color: HubColors.inkMuted),
                title: DSBodyText(
                  logoutString,
                  color: HubColors.inkMuted,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DSSpacing.sm.value),
                ),
                onTap: () => _signOut(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    Navigator.pop(context);
    final result = await dependency<AuthRepository>().signOut();
    if (!context.mounted) return;
    if (result case Error(:final error)) {
      final message = error.toString().replaceFirst('Exception: ', '');
      context.showSnackBarError(message);
    }
  }
}
