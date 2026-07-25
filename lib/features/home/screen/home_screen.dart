import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/strings/strings.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/core/utils/extension/datetime.dart';
import 'package:ufersa_hub/features/activities/domain/models/activity_entry.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/home/screen/components/app_drawer.dart';
import 'package:ufersa_hub/features/home/screen/home_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_loading_widget.dart';
import 'package:ufersa_hub/features/shared/components/body_error_default_widget.dart';
import 'package:ufersa_hub/features/shared/hub/hub.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewmodel});

  final HomeViewModel viewmodel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with RouteAware, HubRouteRefreshMixin {
  HomeViewModel get viewmodel => widget.viewmodel;

  @override
  void initState() {
    super.initState();
    viewmodel.load.execute();
  }

  @override
  void onHubRouteVisible() => viewmodel.load.execute();

  Future<void> _openClassForm({ClassEntry? entry}) async {
    await context.go(AppRouters.classForm, arguments: entry);
    if (!mounted) return;
    viewmodel.load.execute();
  }

  Future<void> _openActivityForm({ActivityEntry? entry}) async {
    await context.go(AppRouters.activityForm, arguments: entry);
    if (!mounted) return;
    viewmodel.load.execute();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: HubAppBar(
        title: homeTodayString,
        leading: Builder(
          builder:
              (context) => IconButton(
                key: const Key('menu_button'),
                tooltip: menuString,
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu_rounded, size: 26),
              ),
        ),
      ),
      drawer: const AppDrawer(),
      body: ListenableBuilder(
        listenable: viewmodel.load,
        builder: (context, _) {
          if (viewmodel.load.running && viewmodel.todayClasses.isEmpty) {
            return const AppLoadingWidget();
          }
          if (viewmodel.load.error) {
            return BodyErrorDefaultWidget(
              title: errorLoadDailyString,
              onPressed: () => viewmodel.load.execute(),
            );
          }
          return RefreshIndicator(
            color: HubColors.seed,
            onRefresh: () async => viewmodel.load.execute(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(DSSpacing.md.value),
              children: [
                HubDayHeader(
                  weekdayLabel: weekdayLabels[now.weekday - 1],
                  dateLabel: formatHubDayHeader(now),
                  classesTodayCount: viewmodel.todayClasses.length,
                  activitiesTodayCount: viewmodel.todayActivities.length,
                ),
                DSSpacing.md.y,
                HubHomeQuickActions(
                  addClassLabel: addClassString,
                  addActivityLabel: addActivityString,
                  onAddClass: () => _openClassForm(),
                  onAddActivity: () => _openActivityForm(),
                ),
                DSSpacing.lg.y,
                HubHomeSection(
                  title: classesTodayString,
                  count: viewmodel.todayClasses.isEmpty
                      ? null
                      : viewmodel.todayClasses.length,
                  actionLabel: myScheduleString,
                  onAction: () =>
                      Navigator.of(context).pushReplacementNamed(
                        AppRouters.classes.path,
                      ),
                  child: viewmodel.todayClasses.isEmpty
                      ? HubEmptyState(
                          embedded: true,
                          icon: Icons.schedule_outlined,
                          title: emptyClassesHomeTitle,
                          message: emptyClassesHomeMessage,
                          actionLabel: addClassString,
                          onAction: () => _openClassForm(),
                        )
                      : Column(
                          children:
                              viewmodel.todayClasses
                                  .map(_classTile)
                                  .toList(),
                        ),
                ),
                DSSpacing.lg.y,
                HubHomeSection(
                  title: activitiesTodayString,
                  count: viewmodel.todayActivities.isEmpty
                      ? null
                      : viewmodel.todayActivities.length,
                  actionLabel: myActivitiesString,
                  onAction: () =>
                      Navigator.of(context).pushReplacementNamed(
                        AppRouters.activities.path,
                      ),
                  child: viewmodel.todayActivities.isEmpty
                      ? HubEmptyState(
                          embedded: true,
                          icon: Icons.task_alt_outlined,
                          title: emptyActivitiesHomeTitle,
                          message: emptyActivitiesHomeMessage,
                          actionLabel: addActivityString,
                          onAction: () => _openActivityForm(),
                        )
                      : Column(
                          children:
                              viewmodel.todayActivities
                                  .map((a) => _activityTile(a))
                                  .toList(),
                        ),
                ),
                DSSpacing.xl.y,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _classTile(ClassEntry entry) {
    return HubClassCard(
      subject: entry.subject,
      startTime: entry.startTime,
      endTime: entry.endTime,
      room: entry.room,
      onTap: () => _openClassForm(entry: entry),
    );
  }

  Widget _activityTile(ActivityEntry entry) {
    return HubActivityTile(
      title: entry.title,
      subtitle: '${entry.kind.label} • ${entry.date.toDateAt}',
      kind: entry.kind,
      done: entry.done,
      onChanged: (_) => viewmodel.toggleActivity.execute(entry),
      onTap: () => _openActivityForm(entry: entry),
    );
  }
}
