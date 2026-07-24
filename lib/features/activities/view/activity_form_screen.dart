import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/strings/strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/core/utils/extension/datetime.dart';
import 'package:ufersa_hub/features/activities/domain/models/activity_entry.dart';
import 'package:ufersa_hub/features/activities/view/activity_form_view_model.dart';
import 'package:ufersa_hub/features/shared/components/news_app_bar.dart';

class ActivityFormScreen extends StatefulWidget {
  const ActivityFormScreen({
    super.key,
    required this.viewmodel,
    this.isEdit = false,
  });

  final ActivityFormViewModel viewmodel;
  final bool isEdit;

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  late final ActivityFormViewModel viewmodel;
  late final TextEditingController titleController;
  late final TextEditingController notesController;

  @override
  void initState() {
    viewmodel = widget.viewmodel;
    viewmodel.hydrate();
    titleController = TextEditingController(text: viewmodel.title);
    notesController = TextEditingController(text: viewmodel.notes);
    viewmodel.save.addListener(_onSave);
    super.initState();
  }

  @override
  void dispose() {
    viewmodel.save.removeListener(_onSave);
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (viewmodel.save.completed) {
      viewmodel.save.clearResult();
      context.back(true);
    }
    if (viewmodel.save.error) {
      context.showSnackBarError(errorSaveString);
      viewmodel.save.clearResult();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: viewmodel.date,
    );
    if (picked != null) {
      setState(() => viewmodel.date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewsAppBar(
        canPop: true,
        title: widget.isEdit ? editActivityString : addActivityString,
      ),
      body: ListView(
        padding: EdgeInsets.all(DSSpacing.md.value),
        children: [
          DSTextFormField(
            controller: titleController,
            hint: activityTitleString,
            onChanged: (v) => viewmodel.title = v,
          ),
          DSSpacing.md.y,
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(activityDateString),
            subtitle: Text(viewmodel.date.toDateAt),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickDate,
          ),
          DSSpacing.md.y,
          DropdownButtonFormField<ActivityKind>(
            value: viewmodel.kind,
            decoration: InputDecoration(labelText: activityTypeString),
            items:
                ActivityKind.values
                    .map(
                      (k) => DropdownMenuItem(
                        value: k,
                        child: Text(k.label),
                      ),
                    )
                    .toList(),
            onChanged:
                (v) => setState(() => viewmodel.kind = v ?? ActivityKind.estudo),
          ),
          DSSpacing.md.y,
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(markDoneString),
            value: viewmodel.done,
            onChanged: (v) => setState(() => viewmodel.done = v),
          ),
          DSSpacing.md.y,
          DSTextFormField(
            controller: notesController,
            hint: notesOptionalString,
            onChanged: (v) => viewmodel.notes = v,
            maxLines: 3,
          ),
          DSSpacing.lg.y,
          ListenableBuilder(
            listenable: viewmodel.save,
            builder:
                (_, __) => DSPrimaryButton(
                  label: saveString,
                  isLoading: viewmodel.save.running,
                  onPressed: () => viewmodel.save.execute(),
                ),
          ),
        ],
      ),
    );
  }
}
