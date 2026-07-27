import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:university_hub/core/dependecy/dependency.dart';
import 'package:university_hub/core/router/app_router.dart';
import 'package:university_hub/core/storage/app_profile_repository.dart';
import 'package:university_hub/core/storage/app_profile_settings.dart';
import 'package:university_hub/core/strings/app_mission.dart';
import 'package:university_hub/core/strings/daily_strings.dart';
import 'package:university_hub/core/theme/hub_colors.dart';
import 'package:university_hub/features/shared/components/app_icon.dart';
import 'package:university_hub/features/shared/hub/hub_nav_tile.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  AppProfileSettings _profile = const AppProfileSettings();
  bool _loadingProfile = true;

  AppProfileRepository get _profileRepo => dependency<AppProfileRepository>();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final loaded = await _profileRepo.load();
    if (!mounted) return;
    setState(() {
      _profile = loaded;
      _loadingProfile = false;
    });
  }

  Future<void> _editUniversityName() async {
    final controller = TextEditingController(text: _profile.universityName ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(universityNameDialogTitleString),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: universityNameDialogHintString,
            ),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelString),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(universityNameDialogSaveString),
            ),
          ],
        );
      },
    );
    if (saved != true || !mounted) return;

    final next = AppProfileSettings(
      universityName: controller.text.trim().isEmpty
          ? null
          : controller.text.trim(),
    );
    await _profileRepo.save(next);
    if (!mounted) return;
    setState(() => _profile = next);
  }

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
                  if (!_loadingProfile)
                    Text(
                      _profile.displayUniversityLabel,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  DSSpacing.xs.y,
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
                    icon: Icons.calendar_view_week_outlined,
                    label: myScheduleString,
                    route: AppRouters.classes,
                    isSelected: currentRoute == AppRouters.classes.path,
                  ),
                  HubNavTile(
                    icon: Icons.checklist_rtl_outlined,
                    label: myActivitiesString,
                    route: AppRouters.activities,
                    isSelected: currentRoute == AppRouters.activities.path,
                  ),
                  ListTile(
                    leading: const Icon(Icons.school_outlined),
                    title: Text(universityNameMenuString),
                    subtitle: _loadingProfile
                        ? null
                        : Text(_profile.displayUniversityLabel),
                    onTap: _editUniversityName,
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
