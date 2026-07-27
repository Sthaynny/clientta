import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:university_hub/core/strings/daily_strings.dart';
import 'package:university_hub/core/strings/strings.dart';
import 'package:university_hub/core/utils/extension/build_context.dart';
import 'package:university_hub/core/utils/extension/datetime.dart';
import 'package:university_hub/features/activities/domain/models/activity_entry.dart';
import 'package:university_hub/features/activities/view/activity_form_view_model.dart';
import 'package:university_hub/features/shared/hub/hub.dart';

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
    super.initState();
    viewmodel = widget.viewmodel;
    viewmodel.hydrate();
    titleController = TextEditingController(text: viewmodel.title);
    notesController = TextEditingController(text: viewmodel.notes);
    viewmodel.save.addListener(_onSave);
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
      appBar: HubAppBar(
        canPop: true,
        showBrandMark: false,
        title: widget.isEdit ? editActivityString : addActivityString,
      ),
      body: ListView(
        padding: EdgeInsets.all(DSSpacing.md.value),
        children: [
          HubTextFormField(
            controller: titleController,
            label: activityTitleString,
            onChanged: (v) => viewmodel.title = v,
          ),
          DSSpacing.md.y,
          HubDateFormField(
            label: activityDateString,
            value: viewmodel.date.toDateAt,
            onTap: _pickDate,
          ),
          DSSpacing.md.y,
          DropdownButtonFormField<ActivityKind>(
            key: ValueKey(viewmodel.kind),
            initialValue: viewmodel.kind,
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
          HubSwitchFormField(
            label: markDoneString,
            value: viewmodel.done,
            onChanged: (v) => setState(() => viewmodel.done = v),
          ),
          DSSpacing.md.y,
          HubTextFormField(
            controller: notesController,
            label: notesOptionalString,
            maxLines: 3,
            onChanged: (v) => viewmodel.notes = v,
          ),
          DSSpacing.lg.y,
          ListenableBuilder(
            listenable: viewmodel.save,
            builder:
                (_, __) => HubPrimaryButton(
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
