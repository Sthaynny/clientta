import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/core/utils/extension/datetime.dart';
import 'package:ufersa_hub/features/activities/domain/models/activity_entry.dart';
import 'package:ufersa_hub/features/activities/view/activities_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_loading_widget.dart';
import 'package:ufersa_hub/features/shared/components/body_error_default_widget.dart';
import 'package:ufersa_hub/features/shared/hub/hub.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key, required this.viewmodel});

  final ActivitiesViewModel viewmodel;

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with RouteAware, HubRouteRefreshMixin {
  ActivitiesViewModel get viewmodel => widget.viewmodel;

  @override
  void initState() {
    super.initState();
    viewmodel.load.execute();
  }

  @override
  void onHubRouteVisible() => viewmodel.load.execute();

  Future<void> _openActivityForm({ActivityEntry? entry}) async {
    await context.go(AppRouters.activityForm, arguments: entry);
    if (!mounted) return;
    viewmodel.load.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        title: myActivitiesString,
        showBrandMark: false,
        onBackButtonPressed:
            () => Navigator.of(context).pushReplacementNamed(
              AppRouters.home.path,
            ),
      ),
      floatingActionButton: HubFab(
        label: addActivityString,
        onPressed: () => _openActivityForm(),
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

          Future<void> onRefresh() async => viewmodel.load.execute();

          if (viewmodel.entries.isEmpty) {
            return RefreshIndicator(
              color: HubColors.seed,
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.65,
                  child: HubEmptyState(
                    icon: Icons.checklist_rtl_outlined,
                    title: emptyActivitiesListTitle,
                    message: emptyActivitiesListMessage,
                    actionLabel: addActivityString,
                    onAction: () => _openActivityForm(),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: HubColors.seed,
            onRefresh: onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(DSSpacing.md.value),
              itemCount: viewmodel.entries.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: DSSpacing.sm.value),
                    child: HubSectionHeader(
                      title: myActivitiesString,
                      count: viewmodel.entries.length,
                    ),
                  );
                }
                final entry = viewmodel.entries[index - 1];
                return HubActivityTile(
                  title: entry.title,
                  subtitle: '${entry.kind.label} • ${entry.date.toDateAt}',
                  kind: entry.kind,
                  done: entry.done,
                  onChanged: (_) => viewmodel.toggleDone.execute(entry),
                  onTap: () => _openActivityForm(entry: entry),
                  onDelete: () => viewmodel.deleteEntry.execute(entry.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
