import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/strings/strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/features/classes/view/class_form_view_model.dart';
import 'package:ufersa_hub/features/shared/hub/hub.dart';

class ClassFormScreen extends StatefulWidget {
  const ClassFormScreen({
    super.key,
    required this.viewmodel,
    this.isEdit = false,
  });

  final ClassFormViewModel viewmodel;
  final bool isEdit;

  @override
  State<ClassFormScreen> createState() => _ClassFormScreenState();
}

class _ClassFormScreenState extends State<ClassFormScreen> {
  late final ClassFormViewModel viewmodel;
  late final TextEditingController subjectController;
  late final TextEditingController startController;
  late final TextEditingController endController;
  late final TextEditingController roomController;
  late final TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    viewmodel = widget.viewmodel;
    viewmodel.hydrate();
    subjectController = TextEditingController(text: viewmodel.subject);
    startController = TextEditingController(text: viewmodel.startTime);
    endController = TextEditingController(text: viewmodel.endTime);
    roomController = TextEditingController(text: viewmodel.room);
    notesController = TextEditingController(text: viewmodel.notes);
    viewmodel.save.addListener(_onSave);
  }

  @override
  void dispose() {
    viewmodel.save.removeListener(_onSave);
    subjectController.dispose();
    startController.dispose();
    endController.dispose();
    roomController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        showBrandMark: false,
        title: widget.isEdit ? editClassString : addClassString,
      ),
      body: ListView(
        padding: EdgeInsets.all(DSSpacing.md.value),
        children: [
          DropdownButtonFormField<int>(
            key: ValueKey(viewmodel.weekday),
            initialValue: viewmodel.weekday,
            decoration: InputDecoration(labelText: weekdayString),
            items: List.generate(
              7,
              (i) => DropdownMenuItem(
                value: i + 1,
                child: Text(weekdayLabels[i]),
              ),
            ),
            onChanged: (v) => setState(() => viewmodel.weekday = v ?? 1),
          ),
          DSSpacing.md.y,
          HubTextFormField(
            controller: subjectController,
            label: subjectString,
            onChanged: (v) => viewmodel.subject = v,
          ),
          DSSpacing.md.y,
          Row(
            children: [
              Expanded(
                child: HubTextFormField(
                  controller: startController,
                  label: startTimeString,
                  onChanged: (v) => viewmodel.startTime = v,
                ),
              ),
              DSSpacing.sm.x,
              Expanded(
                child: HubTextFormField(
                  controller: endController,
                  label: endTimeString,
                  onChanged: (v) => viewmodel.endTime = v,
                ),
              ),
            ],
          ),
          DSSpacing.md.y,
          HubTextFormField(
            controller: roomController,
            label: roomString,
            onChanged: (v) => viewmodel.room = v,
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
