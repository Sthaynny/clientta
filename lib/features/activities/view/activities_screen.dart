import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/core/utils/extension/datetime.dart';
import 'package:ufersa_hub/features/activities/domain/models/activity_entry.dart';
import 'package:ufersa_hub/features/activities/view/activities_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_loading_widget.dart';
import 'package:ufersa_hub/features/shared/components/body_error_default_widget.dart';
import 'package:ufersa_hub/features/shared/hub/hub_activity_tile.dart';
import 'package:ufersa_hub/features/shared/hub/hub_app_bar.dart';
import 'package:ufersa_hub/features/shared/hub/hub_empty_state.dart';
import 'package:ufersa_hub/features/shared/hub/hub_fab.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key, required this.viewmodel});

  final ActivitiesViewModel viewmodel;

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewmodel.load.execute();
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = widget.viewmodel;

    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        title: myActivitiesString,
        showBrandMark: false,
      ),
      floatingActionButton: HubFab(
        label: addActivityString,
        onPressed: () async {
          await context.go(AppRouters.activityForm);
          viewmodel.load.execute();
        },
      ),
      body: ListenableBuilder(
        listenable: viewmodel.load,
        builder: (context, _) {
          if (viewmodel.load.running && viewmodel.entries.isEmpty) {
            return const AppLoadingWidget();
          }
          if (viewmodel.load.error) {
            return BodyErrorDefaultWidget(
              title: errorLoadDailyString,
              onPressed: () => viewmodel.load.execute(),
            );
          }
          if (viewmodel.entries.isEmpty) {
            return HubEmptyState(
              icon: Icons.checklist_rtl_outlined,
              title: emptyActivitiesListTitle,
              message: emptyActivitiesListMessage,
              actionLabel: addActivityString,
              onAction: () => context.go(AppRouters.activityForm),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(DSSpacing.md.value),
            itemCount: viewmodel.entries.length,
            itemBuilder: (context, index) {
              final entry = viewmodel.entries[index];
              return HubActivityTile(
                title: entry.title,
                subtitle: '${entry.kind.label} • ${entry.date.toDateAt}',
                kind: entry.kind,
                done: entry.done,
                onChanged: (_) => viewmodel.toggleDone.execute(entry),
                onTap: () async {
                  await context.go(AppRouters.activityForm, arguments: entry);
                  viewmodel.load.execute();
                },
                onDelete: () => viewmodel.deleteEntry.execute(entry.id),
              );
            },
          );
        },
      ),
    );
  }
}
