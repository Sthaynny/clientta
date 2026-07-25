import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_schedule_group.dart';
import 'package:ufersa_hub/features/classes/view/classes_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_loading_widget.dart';
import 'package:ufersa_hub/features/shared/components/body_error_default_widget.dart';
import 'package:ufersa_hub/features/shared/hub/hub_app_bar.dart';
import 'package:ufersa_hub/features/shared/hub/hub_class_card.dart';
import 'package:ufersa_hub/features/shared/hub/hub_empty_state.dart';
import 'package:ufersa_hub/features/shared/hub/hub_fab.dart';

enum _ClassDeleteScope { singleDay, entireSeries }

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key, required this.viewmodel});

  final ClassesViewModel viewmodel;

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewmodel.load.execute();
  }

  Future<void> _confirmDelete(ClassScheduleGroup group) async {
    final viewmodel = widget.viewmodel;
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
    final viewmodel = widget.viewmodel;

    return Scaffold(
      appBar: HubAppBar(canPop: true, title: myScheduleString, showBrandMark: false),
      floatingActionButton: HubFab(
        label: addClassString,
        onPressed: () async {
          await context.go(AppRouters.classForm);
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
              icon: Icons.calendar_view_week_outlined,
              title: emptyScheduleTitle,
              message: emptyScheduleMessage,
              actionLabel: addClassString,
              onAction: () => context.go(AppRouters.classForm),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(DSSpacing.md.value),
            itemCount: viewmodel.groups.length,
            itemBuilder: (context, index) {
              final group = viewmodel.groups[index];
              final entry = group.representative;
              return HubClassCard(
                subject: entry.subject,
                startTime: entry.startTime,
                endTime: entry.endTime,
                room: entry.room,
                weekdayLabel: group.combinedWeekdayLabel,
                onEdit: () async {
                  await context.go(AppRouters.classForm, arguments: entry);
                  viewmodel.load.execute();
                },
                onDelete: () => _confirmDelete(group),
              );
            },
          );
        },
      ),
    );
  }
}
