import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/core/utils/input_masks.dart';
import 'package:clientta/core/utils/extension/datetime.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/domain/appointment_client_match.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/view/appointment_form_view_model.dart';
import 'package:clientta/features/shared/hub/hub.dart';

class AppointmentFormScreen extends StatefulWidget {
  const AppointmentFormScreen({
    super.key,
    required this.viewmodel,
    this.isEdit = false,
  });

  final AppointmentFormViewModel viewmodel;
  final bool isEdit;

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  late final AppointmentFormViewModel viewmodel;
  late final TextEditingController clientNameController;
  late final TextEditingController clientPhoneController;
  late final TextEditingController serviceTypeController;
  late final TextEditingController notesController;
  final _formKey = GlobalKey<FormState>();
  bool _saveSubmitted = false;

  @override
  void initState() {
    super.initState();
    viewmodel = widget.viewmodel;
    viewmodel.hydrate();
    clientNameController = TextEditingController(text: viewmodel.clientName);
    clientPhoneController = TextEditingController(
      text: formatBrPhone(viewmodel.clientPhone),
    );
    serviceTypeController = TextEditingController(text: viewmodel.serviceType);
    notesController = TextEditingController(text: viewmodel.notes);
    viewmodel.save.addListener(_onSave);
    _loadReferenceData();
  }

  Future<void> _loadReferenceData() async {
    await viewmodel.refreshKnownAppointments();
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    viewmodel.save.removeListener(_onSave);
    clientNameController.dispose();
    clientPhoneController.dispose();
    serviceTypeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  String _saveErrorMessage() {
    final result = viewmodel.save.result;
    if (result case Error(:final error)) {
      final text = error.toString();
      const prefix = 'Exception: ';
      if (text.startsWith(prefix)) {
        return text.substring(prefix.length);
      }
      return text;
    }
    return errorSaveString;
  }

  void _onSave() {
    if (viewmodel.save.completed) {
      viewmodel.save.clearResult();
      context.back(true);
    }
    if (viewmodel.save.error) {
      setState(() {});
      context.showSnackBarError(_saveErrorMessage());
      viewmodel.save.clearResult();
    }
  }

  Future<SeriesEditScope?> _resolveSeriesEditScope() async {
    if (!viewmodel.isSeriesEdit) return SeriesEditScope.single;

    final choice = await showHubChoiceDialog(
      context: context,
      title: editSeriesTitleString,
      message: editSeriesMessageString,
      firstLabel: editSeriesOneLabelString,
      secondLabel: editSeriesAllLabelString,
    );
    return switch (choice) {
      HubChoiceResult.first => SeriesEditScope.single,
      HubChoiceResult.second => SeriesEditScope.entireSeries,
      HubChoiceResult.cancelled => null,
    };
  }

  Future<ClientPhoneMatchChoice?> _resolveClientPhoneMatch(
    ExistingClientMatch match,
  ) async {
    final choice = await showHubChoiceDialog(
      context: context,
      title: clientPhoneMatchTitleString,
      message: clientPhoneMatchMessageString(match.existingName),
      firstLabel: clientPhoneMatchMergeLabelString,
      secondLabel: clientPhoneMatchCreateNewLabelString,
    );
    return switch (choice) {
      HubChoiceResult.first => ClientPhoneMatchChoice.mergeExisting,
      HubChoiceResult.second => ClientPhoneMatchChoice.createNew,
      HubChoiceResult.cancelled => null,
    };
  }

  Future<bool> _ensureClientPhoneResolved() async {
    if (viewmodel.isEdit || viewmodel.lockClientFields) return true;

    final match = viewmodel.existingClientMatchForPhone(viewmodel.clientPhone);
    if (match == null) return true;
    if (viewmodel.hasResolvedClientPhone(viewmodel.clientPhone)) return true;

    final choice = await _resolveClientPhoneMatch(match);
    if (!mounted || choice == null) return false;

    viewmodel.applyClientPhoneMatchChoice(choice: choice, match: match);
    if (choice == ClientPhoneMatchChoice.mergeExisting) {
      clientNameController.text = match.existingName;
    }
    setState(() {});
    return true;
  }

  Future<void> _submit() async {
    if (_saveSubmitted || viewmodel.save.running) return;

    final scope = await _resolveSeriesEditScope();
    if (!mounted || scope == null) return;

    viewmodel.pendingSeriesEditScope = scope;
    final resolvedClient = await _ensureClientPhoneResolved();
    if (!mounted || !resolvedClient) return;

    if (!viewmodel.validateFields()) {
      setState(() {});
      return;
    }

    _saveSubmitted = true;
    await viewmodel.save.execute();
    if (!mounted) return;
    if (viewmodel.save.error) {
      _saveSubmitted = false;
    }
  }

  Future<void> _onClientPhoneChanged(String value) async {
    viewmodel.clientPhone = value;
    viewmodel.clearFieldError('clientPhone');

    if (!viewmodel.isEdit && !viewmodel.lockClientFields) {
      final match = viewmodel.existingClientMatchForPhone(value);
      if (match == null) {
        viewmodel.resetClientPhoneResolution();
      } else if (!viewmodel.hasResolvedClientPhone(value)) {
        final choice = await _resolveClientPhoneMatch(match);
        if (!mounted || choice == null) return;
        viewmodel.applyClientPhoneMatchChoice(choice: choice, match: match);
        if (choice == ClientPhoneMatchChoice.mergeExisting) {
          clientNameController.text = match.existingName;
        }
      }
    }

    setState(() {});
  }

  TimeOfDay _timeFromHhMm(String value) {
    final parts = value.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]) ?? 9;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(
        hour: hour.clamp(0, 23),
        minute: minute.clamp(0, 59),
      );
    }
    return const TimeOfDay(hour: 9, minute: 0);
  }

  String _hhMmFromTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<TimeOfDay?> _pickTime(TimeOfDay initial) {
    return showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(primary: HubColors.seed),
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _pickStartTime() async {
    final picked = await _pickTime(_timeFromHhMm(viewmodel.startTime));
    if (picked != null) {
      setState(() {
        viewmodel.setStartTime(_hhMmFromTime(picked));
        viewmodel.clearFieldError('startTime');
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: viewmodel.appointmentDate,
    );
    if (picked != null) {
      setState(() => viewmodel.appointmentDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final errors = viewmodel.fieldErrors;

    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        showBrandMark: false,
        title: widget.isEdit
            ? editAppointmentString
            : viewmodel.lockClientFields
            ? scheduleClientReminderTitleString
            : addAppointmentString,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(DSSpacing.md.value),
          children: [
            HubTextFormField(
              controller: clientNameController,
              label: clientNameString,
              enabled: !viewmodel.lockClientFields,
              errorText: errors.clientName,
              onChanged: viewmodel.lockClientFields
                  ? null
                  : (value) {
                    viewmodel.clientName = value;
                    viewmodel.clearFieldError('clientName');
                    setState(() {});
                  },
            ),
            DSSpacing.md.y,
            HubTextFormField(
              controller: clientPhoneController,
              label: clientPhoneString,
              enabled: !viewmodel.lockClientFields,
              keyboardType: TextInputType.phone,
              inputFormatters: InputMaskFormatters.brPhone,
              autofillHints: const [AutofillHints.telephoneNumber],
              errorText: errors.clientPhone,
              onChanged:
                  viewmodel.lockClientFields ? null : _onClientPhoneChanged,
            ),
            DSSpacing.md.y,
            HubServiceTypeField(
              controller: serviceTypeController,
              options: viewmodel.serviceTypeOptions,
              label: serviceTypeString,
              hint: serviceTypeHintString,
              errorText: errors.serviceType,
              onChanged: (value) {
                viewmodel.serviceType = value;
                viewmodel.clearFieldError('serviceType');
                setState(() {});
              },
            ),
            DSSpacing.md.y,
            HubDateFormField(
              label: appointmentDateString,
              value: viewmodel.appointmentDate.toDateAt,
              onTap: _pickDate,
            ),
            DSSpacing.md.y,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HubTimeFormField(
                  label: startTimeString,
                  value: viewmodel.startTime,
                  onTap: _pickStartTime,
                ),
                if (errors.startTime != null)
                  Padding(
                    padding: EdgeInsets.only(
                      top: DSSpacing.xxs.value,
                      left: DSSpacing.sm.value,
                    ),
                    child: Text(
                      errors.startTime!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            DSSpacing.md.y,
            DropdownButtonFormField<String>(
              key: ValueKey(viewmodel.status),
              initialValue: viewmodel.status,
              decoration: InputDecoration(labelText: appointmentStatusString),
              items:
                  AppointmentStatus.values
                      .map(
                        (status) => DropdownMenuItem(
                          value: status.value,
                          child: Text(status.label),
                        ),
                      )
                      .toList(),
              onChanged:
                  (value) => setState(
                    () =>
                        viewmodel.status =
                            value ?? AppointmentStatus.agendado.value,
                  ),
            ),
            DSSpacing.md.y,
            HubTextFormField(
              controller: notesController,
              label: viewmodel.lockClientFields
                  ? appointmentReminderNotesLabelString
                  : notesOptionalString,
              hint: viewmodel.lockClientFields
                  ? appointmentReminderNotesHintString
                  : null,
              maxLines: 3,
              onChanged: (value) => viewmodel.notes = value,
            ),
            if (!widget.isEdit && !viewmodel.lockClientFields) ...[
              DSSpacing.md.y,
              DSCaptionText(
                recurringSeriesLabelString,
                color: HubColors.inkMuted,
                fontWeight: FontWeight.w600,
              ),
              DSSpacing.xxs.y,
              DSCaptionText(
                recurringSeriesHintString,
                color: HubColors.inkMuted,
              ),
              DSSpacing.sm.y,
              HubWeekdayChips(
                selectedWeekdays: viewmodel.selectedWeekdays,
                onChanged: (value) {
                  setState(() => viewmodel.selectedWeekdays = value);
                },
              ),
            ],
            DSSpacing.xl.y,
            ListenableBuilder(
              listenable: viewmodel.save,
              builder:
                  (_, __) => HubPrimaryButton(
                    label: saveString,
                    isLoading: viewmodel.save.running,
                    isEnabled: !_saveSubmitted,
                    onPressed: _submit,
                  ),
            ),
            DSSpacing.md.y,
          ],
        ),
      ),
    );
  }
}
