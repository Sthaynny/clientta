import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/core/utils/extension/datetime.dart';
import 'package:ufersa_hub/features/activities/domain/models/activity_entry.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/home/screen/components/app_drawer.dart';
import 'package:ufersa_hub/features/home/screen/home_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_loading_widget.dart';
import 'package:ufersa_hub/features/shared/components/body_error_default_widget.dart';
import 'package:ufersa_hub/features/shared/components/news_app_bar.dart';
import 'package:ufersa_hub/features/shared/widgets/university_info_strip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewmodel});

  final HomeViewModel viewmodel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewmodel.load.execute();
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = widget.viewmodel;

    return Scaffold(
      appBar: NewsAppBar(
        title: homeTodayString,
        leading: Builder(
          builder:
              (context) => DSIconButton(
                key: const Key('menu_button'),
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: DSIcons.menu_dot_outline,
              ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const UniversityInfoStrip(),
          Expanded(
            child: ListenableBuilder(
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
                  onRefresh: () async => viewmodel.load.execute(),
                  child: ListView(
                    padding: EdgeInsets.all(DSSpacing.md.value),
                    children: [
                      DSHeadlineSmallText(classesTodayString),
                      DSSpacing.sm.y,
                      if (viewmodel.todayClasses.isEmpty)
                        DSBodyText(noClassesTodayString)
                      else
                        ...viewmodel.todayClasses.map(_classTile),
                      DSSpacing.lg.y,
                      DSHeadlineSmallText(activitiesTodayString),
                      DSSpacing.sm.y,
                      if (viewmodel.todayActivities.isEmpty)
                        DSBodyText(noActivitiesTodayString)
                      else
                        ...viewmodel.todayActivities.map(
                          (a) => _activityTile(context, viewmodel, a),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _classTile(ClassEntry entry) {
    final room = entry.room;
    return Card(
      margin: EdgeInsets.only(bottom: DSSpacing.xs.value),
      child: ListTile(
        title: DSHeadlineSmallText(entry.subject),
        subtitle: DSBodyText(
          '${entry.startTime} – ${entry.endTime}'
          '${room != null ? ' • $room' : ''}',
        ),
      ),
    );
  }

  Widget _activityTile(
    BuildContext context,
    HomeViewModel viewmodel,
    ActivityEntry entry,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: DSSpacing.xs.value),
      child: CheckboxListTile(
        value: entry.done,
        onChanged: (_) => viewmodel.toggleActivity.execute(entry),
        title: DSBodyText(
          entry.title,
          maxLines: 2,
        ),
        subtitle: DSBodyText(
          '${entry.kind.label} • ${entry.date.toDateAt}',
        ),
        onTap: () async {
          await context.go(AppRouters.activityForm, arguments: entry);
          viewmodel.load.execute();
        },
      ),
    );
  }
}
