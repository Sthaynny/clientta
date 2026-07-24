import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/classes/view/classes_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_loading_widget.dart';
import 'package:ufersa_hub/features/shared/components/body_error_default_widget.dart';
import 'package:ufersa_hub/features/shared/components/button_add_item_widget.dart';
import 'package:ufersa_hub/features/shared/components/news_app_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    final viewmodel = widget.viewmodel;

    return Scaffold(
      appBar: NewsAppBar(canPop: true, title: myScheduleString),
      floatingActionButton: ButtonAddItemWidget(
        label: addClassString,
        isVisible: true,
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
            return Center(child: DSBodyText(noClassesTodayString));
          }

          return ListView.builder(
            padding: EdgeInsets.all(DSSpacing.md.value),
            itemCount: viewmodel.entries.length,
            itemBuilder: (context, index) {
              final entry = viewmodel.entries[index];
              return _ClassCard(
                entry: entry,
                onEdit: () async {
                  await context.go(AppRouters.classForm, arguments: entry);
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

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  final ClassEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final day = weekdayLabels[entry.weekday - 1];
    return Card(
      margin: EdgeInsets.only(bottom: DSSpacing.sm.value),
      child: ListTile(
        title: DSHeadlineSmallText(entry.subject),
        subtitle: DSBodyText(
          '$day • ${entry.startTime} – ${entry.endTime}'
          '${entry.room != null ? '\n${entry.room}' : ''}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete_outline, color: DSColors.error),
            ),
          ],
        ),
      ),
    );
  }
}
