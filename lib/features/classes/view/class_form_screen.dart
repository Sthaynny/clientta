import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/strings/strings.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/classes/view/class_form_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_loading_widget.dart';
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
  late final TextEditingController roomController;
  late final TextEditingController notesController;
  bool _hydrating = true;

  @override
  void initState() {
    super.initState();
    viewmodel = widget.viewmodel;
    subjectController = TextEditingController(text: viewmodel.subject);
    roomController = TextEditingController(text: viewmodel.room);
    notesController = TextEditingController(text: viewmodel.notes);
    viewmodel.save.addListener(_onSave);
    _hydrate();
  }

  Future<void> _hydrate() async {
    await viewmodel.hydrate();
    if (!mounted) return;
    subjectController.text = viewmodel.subject;
    roomController.text = viewmodel.room;
    notesController.text = viewmodel.notes;
    setState(() => _hydrating = false);
  }

  @override
  void dispose() {
    viewmodel.save.removeListener(_onSave);
    subjectController.dispose();
    roomController.dispose();
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
      context.showSnackBarError(_saveErrorMessage());
      viewmodel.save.clearResult();
    }
  }

  TimeOfDay _timeFromHhMm(String value) {
    final parts = value.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]) ?? 8;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(
        hour: hour.clamp(0, 23),
        minute: minute.clamp(0, 59),
      );
    }
    return const TimeOfDay(hour: 8, minute: 0);
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

  Future<void> _pickSharedStartTime() async {
    final picked = await _pickTime(_timeFromHhMm(viewmodel.startTime));
    if (picked != null) {
      setState(
        () => viewmodel.updateSharedStartTime(_hhMmFromTime(picked)),
      );
    }
  }

  Future<void> _pickSharedEndTime() async {
    final picked = await _pickTime(_timeFromHhMm(viewmodel.endTime));
    if (picked != null) {
      setState(() => viewmodel.updateSharedEndTime(_hhMmFromTime(picked)));
    }
  }

  Future<void> _pickDayStartTime(int weekday) async {
    final slot = viewmodel.scheduleForWeekday(weekday);
    final picked = await _pickTime(
      _timeFromHhMm(slot?.startTime ?? viewmodel.startTime),
    );
    if (picked != null) {
      setState(
        () => viewmodel.updateDayStartTime(weekday, _hhMmFromTime(picked)),
      );
    }
  }

  Future<void> _pickDayEndTime(int weekday) async {
    final slot = viewmodel.scheduleForWeekday(weekday);
    final picked = await _pickTime(
      _timeFromHhMm(slot?.endTime ?? viewmodel.endTime),
    );
    if (picked != null) {
      setState(
        () => viewmodel.updateDayEndTime(weekday, _hhMmFromTime(picked)),
      );
    }
  }

  Widget _buildSharedTimeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: HubTimeFormField(
                label: startTimeString,
                value: viewmodel.startTime,
                onTap: _pickSharedStartTime,
              ),
            ),
            DSSpacing.sm.x,
            Expanded(
              child: HubTimeFormField(
                label: endTimeString,
                value: viewmodel.endTime,
                onTap: _pickSharedEndTime,
              ),
            ),
          ],
        ),
        HubNightShiftPresets(
          onApply: (start, end) {
            setState(() => viewmodel.applyTimeRange(start, end));
          },
        ),
      ],
    );
  }

  Widget _buildPerDayTimeFields() {
    final days = viewmodel.selectedWeekdays.toList()..sort();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DSCaptionText(
          classPerDayTimesHintString,
          color: HubColors.inkMuted,
        ),
        DSSpacing.sm.y,
        for (final weekday in days) ...[
          if (weekday != days.first) DSSpacing.md.y,
          HubSurface(
            padding: EdgeInsets.all(DSSpacing.sm.value),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DSBodyText(
                  weekdayLabels[weekday - 1],
                  fontWeight: FontWeight.w600,
                  color: HubColors.ink,
                ),
                DSSpacing.sm.y,
                Row(
                  children: [
                    Expanded(
                      child: HubTimeFormField(
                        label: startTimeString,
                        value:
                            viewmodel.scheduleForWeekday(weekday)?.startTime ??
                            viewmodel.startTime,
                        onTap: () => _pickDayStartTime(weekday),
                      ),
                    ),
                    DSSpacing.sm.x,
                    Expanded(
                      child: HubTimeFormField(
                        label: endTimeString,
                        value:
                            viewmodel.scheduleForWeekday(weekday)?.endTime ??
                            viewmodel.endTime,
                        onTap: () => _pickDayEndTime(weekday),
                      ),
                    ),
                  ],
                ),
                HubNightShiftPresets(
                  onApply: (start, end) {
                    setState(
                      () => viewmodel.applyTimeRange(
                        start,
                        end,
                        weekday: weekday,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScheduleSection(bool showSameTimeSwitch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HubSectionHeader(title: classScheduleSectionString),
        if (showSameTimeSwitch) ...[
          HubSwitchFormField(
            label: classSameTimeSwitchString,
            subtitle: classSameTimeSwitchSubtitleString,
            value: viewmodel.sameTimeForAllDays,
            onChanged: (value) {
              setState(() => viewmodel.setSameTimeForAllDays(value));
            },
          ),
          DSSpacing.md.y,
        ],
        if (!showSameTimeSwitch || viewmodel.sameTimeForAllDays)
          _buildSharedTimeFields()
        else
          _buildPerDayTimeFields(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hydrating) {
      return Scaffold(
        appBar: HubAppBar(
          canPop: true,
          showBrandMark: false,
          title: widget.isEdit ? editClassString : addClassString,
        ),
        body: const AppLoadingWidget(),
      );
    }

    final showSameTimeSwitch = viewmodel.selectedWeekdays.length > 1;

    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        showBrandMark: false,
        title: widget.isEdit ? editClassString : addClassString,
      ),
      body: ListView(
        padding: EdgeInsets.all(DSSpacing.md.value),
        children: [
          HubWeekdayChips(
            label: classWeekdaysSectionString,
            selectedWeekdays: viewmodel.selectedWeekdays,
            onChanged: (weekdays) {
              setState(() => viewmodel.toggleWeekdays(weekdays));
            },
          ),
          DSSpacing.xs.y,
          DSCaptionText(
            classWeekdaysHintString,
            color: HubColors.inkMuted,
          ),
          DSSpacing.lg.y,
          HubTextFormField(
            controller: subjectController,
            label: subjectString,
            onChanged: (v) => viewmodel.subject = v,
          ),
          DSSpacing.lg.y,
          _buildScheduleSection(showSameTimeSwitch),
          DSSpacing.lg.y,
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
          DSSpacing.xl.y,
          ListenableBuilder(
            listenable: viewmodel.save,
            builder:
                (_, __) => HubPrimaryButton(
                  label: saveString,
                  isLoading: viewmodel.save.running,
                  onPressed: () => viewmodel.save.execute(),
                ),
          ),
          DSSpacing.md.y,
        ],
      ),
    );
  }
}
