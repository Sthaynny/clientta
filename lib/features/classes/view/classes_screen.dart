import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_schedule_group.dart';
import 'package:ufersa_hub/features/classes/view/classes_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_loading_widget.dart';
import 'package:ufersa_hub/features/shared/components/body_error_default_widget.dart';
import 'package:ufersa_hub/features/shared/hub/hub.dart';
enum _ClassDeleteScope { singleDay, entireSeries }

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key, required this.viewmodel});

  final ClassesViewModel viewmodel;

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen>
    with RouteAware, HubRouteRefreshMixin {
  ClassesViewModel get viewmodel => widget.viewmodel;

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

  Future<void> _confirmDelete(ClassScheduleGroup group) async {
    final representative = group.representative;

    if (group.entries.length == 1) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(deleteClassSingleDayTitleString),
              content: Text(deleteClassSingleDayMessageString),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(deleteClassKeepActionString),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(deleteClassConfirmSingleDayActionString),
                ),
              ],
            ),
      );
      if (confirmed == true && mounted) {
        await viewmodel.deleteGroup.execute([representative.id]);
      }
      return;
    }

    final scope = await showDialog<_ClassDeleteScope>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(deleteClassChooseTitleString),
            content: Text(deleteClassChooseMessageString),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(cancelString),
              ),
              TextButton(
                onPressed:
                    () => Navigator.of(context).pop(_ClassDeleteScope.singleDay),
                child: Text(deleteClassThisDayString),
              ),
              TextButton(
                onPressed:
                    () =>
                        Navigator.of(context).pop(_ClassDeleteScope.entireSeries),
                child: Text(deleteClassEntireSeriesString),
              ),
            ],
          ),
    );

    if (!mounted || scope == null) return;

    if (scope == _ClassDeleteScope.singleDay) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(deleteClassSingleDayTitleString),
              content: Text(deleteClassSingleDayMessageString),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(deleteClassKeepActionString),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(deleteClassConfirmSingleDayActionString),
                ),
              ],
            ),
      );
      if (confirmed == true && mounted) {
        await viewmodel.deleteGroup.execute([representative.id]);
      }
      return;
    }

    final confirmedSeries = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(deleteClassSeriesTitleString),
            content: Text(deleteClassSeriesMessageString),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(deleteClassKeepActionString),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(deleteClassConfirmSeriesActionString),
              ),
            ],
          ),
    );
    if (confirmedSeries == true && mounted) {
      await viewmodel.deleteGroup.execute(group.entryIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        title: myScheduleString,
        showBrandMark: false,
        onBackButtonPressed:
            () => Navigator.of(context).pushReplacementNamed(
              AppRouters.home.path,
            ),
      ),
      floatingActionButton: HubFab(
        label: addClassString,
        onPressed: () => _openClassForm(),
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
                    icon: Icons.calendar_view_week_outlined,
                    title: emptyScheduleTitle,
                    message: emptyScheduleMessage,
                    actionLabel: addClassString,
                    onAction: () => _openClassForm(),
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
              itemCount: viewmodel.groups.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: DSSpacing.sm.value),
                    child: HubSectionHeader(
                      title: myScheduleString,
                      count: viewmodel.groups.length,
                    ),
                  );
                }
                final group = viewmodel.groups[index - 1];
                final entry = group.displayTimeEntry;
                return HubClassCard(
                  subject: entry.subject,
                  startTime: entry.startTime,
                  endTime: entry.endTime,
                  timeVaries: group.hasVaryingTimes,
                  room: entry.room,
                  weekdayLabel: group.combinedWeekdayLabel,
                  onTap: () => _openClassForm(entry: entry),
                  onEdit: () => _openClassForm(entry: entry),
                  onDelete: () => _confirmDelete(group),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
