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
import 'package:ufersa_hub/features/shared/components/button_add_item_widget.dart';
import 'package:ufersa_hub/features/shared/components/news_app_bar.dart';

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
      appBar: NewsAppBar(canPop: true, title: myActivitiesString),
      floatingActionButton: ButtonAddItemWidget(
        label: addActivityString,
        isVisible: true,
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
            return Center(child: DSBodyText(noActivitiesTodayString));
          }

          return ListView.builder(
            padding: EdgeInsets.all(DSSpacing.md.value),
            itemCount: viewmodel.entries.length,
            itemBuilder: (context, index) {
              final entry = viewmodel.entries[index];
              return Card(
                margin: EdgeInsets.only(bottom: DSSpacing.sm.value),
                child: CheckboxListTile(
                  value: entry.done,
                  onChanged: (_) => viewmodel.toggleDone.execute(entry),
                  title: DSBodyText(entry.title, maxLines: 2),
                  subtitle: DSBodyText(
                    '${entry.kind.label} • ${entry.date.toDateAt}',
                  ),
                  onTap: () async {
                    await context.go(AppRouters.activityForm, arguments: entry);
                    viewmodel.load.execute();
                  },
                  secondary: IconButton(
                    icon: Icon(Icons.delete_outline, color: DSColors.error),
                    onPressed: () => viewmodel.deleteEntry.execute(entry.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
