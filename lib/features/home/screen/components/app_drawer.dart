import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/config/app_config.dart';
import 'package:ufersa_hub/core/config/community_access.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/app_mission.dart';
import 'package:ufersa_hub/core/strings/strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/features/home/screen/home_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_icon.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.viewmodel});
  final HomeViewModel viewmodel;

  Widget _addPadding(Widget child) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: DSSpacing.md.value,
      vertical: DSSpacing.xxs.value,
    ),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    final showAuthActions = AppConfig.requireAuthentication;

    return Drawer(
      child: ListView(
        shrinkWrap: true,
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
                    AppIcon(scale: 30),
                    DSSpacing.xs.x,
                    Expanded(
                      child: DSHeadlineLargeText(
                        menuString,
                        color: DSColors.white,
                      ),
                    ),
                  ],
                ),
                DSSpacing.xs.y,
                DSBodyText(
                  CommunityAccess.isOpenCommunity
                      ? AppMission.drawerSubtitle
                      : AppMission.name,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          _addPadding(
            DSGhostButton(
              onPressed: () {
                context.go(AppRouters.events);
              },
              label: eventsString,
            ),
          ),
          _addPadding(
            DSGhostButton(
              onPressed: () {
                context.go(AppRouters.documents);
              },
              label: documentsString,
            ),
          ),
          if (showAuthActions) ...[
            _addPadding(
              DSGhostButton(
                onPressed: () => context.go(AppRouters.login),
                label: loginString,
              ),
            ),
            ListenableBuilder(
              listenable: viewmodel.logout,
              builder:
                  (context, child) =>
                      viewmodel.userAuthenticated
                          ? _addPadding(
                            DSPrimaryButton(
                              onPressed: () {
                                viewmodel.logout.execute();
                              },
                              label: logoutString,
                              backgroundColor: DSColors.error,
                              trailingIcon: Icon(
                                DSIcons.exit_outline.data,
                                color: Colors.white,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }
}
