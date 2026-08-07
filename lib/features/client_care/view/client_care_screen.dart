import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/core/utils/input_masks.dart';
import 'package:clientta/features/appointments/domain/models/appointment_form_launch_args.dart';
import 'package:clientta/features/client_care/view/client_care_view_model.dart';
import 'package:clientta/features/shared/components/body_error_default_widget.dart';
import 'package:clientta/features/shared/hub/hub.dart';

class ClientCareScreen extends StatefulWidget {
  const ClientCareScreen({super.key, required this.viewmodel});

  final ClientCareViewModel viewmodel;

  @override
  State<ClientCareScreen> createState() => _ClientCareScreenState();
}

class _ClientCareScreenState extends State<ClientCareScreen> {
  ClientCareViewModel get viewmodel => widget.viewmodel;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewmodel.load.execute();
    viewmodel.addNote.addListener(_onAddNote);
  }

  @override
  void dispose() {
    viewmodel.addNote.removeListener(_onAddNote);
    _noteController.dispose();
    super.dispose();
  }

  void _onAddNote() {
    if (!mounted) return;
    if (viewmodel.addNote.completed) {
      _noteController.clear();
      if (viewmodel.addNote.result case Ok(value: final addResult)
          when addResult != null) {
        if (addResult == AddEncounterNoteResult.saved) {
          context.showSnackBarSuccess(encounterNoteSavedString);
        } else {
          context.showSnackBarInfo(encounterAlreadyRegisteredTodayString);
        }
      }
      viewmodel.addNote.clearResult();
    } else if (viewmodel.addNote.error) {
      context.showSnackBarError(errorSaveString);
      viewmodel.addNote.clearResult();
    }
  }

  Future<void> _submitNote() async {
    await viewmodel.addNote.execute(_noteController.text);
  }

  Future<void> _openScheduleAppointment() async {
    final args = viewmodel.args;
    await context.go(
      AppRouters.appointmentForm,
      arguments: AppointmentFormLaunchArgs.prefill(
        clientName: args.clientName,
        clientPhone: args.clientPhone,
        serviceType: args.serviceType,
      ),
    );
    if (!mounted) return;
    viewmodel.load.execute();
  }

  @override
  Widget build(BuildContext context) {
    final args = viewmodel.args;

    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        title: clientCareTitleString,
        showBrandMark: false,
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([viewmodel.load, viewmodel.addNote]),
        builder: (context, _) {
          if (viewmodel.load.running && viewmodel.timeline.isEmpty) {
            return const HubClientCareLoadingSkeleton();
          }
          if (viewmodel.load.error) {
            return BodyErrorDefaultWidget(
              title: errorLoadDailyString,
              onPressed: () => viewmodel.load.execute(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: HubColors.seed,
                  onRefresh: () async => viewmodel.load.execute(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(DSSpacing.md.value),
                    children: [
                      _ClientHeader(
                        clientName: args.clientName,
                        clientPhone: args.clientPhone,
                        serviceType: args.serviceType,
                        onScheduleAppointment: _openScheduleAppointment,
                        onContactLaunchFailed: () => context.showSnackBarError(
                          clientContactLaunchFailedString,
                        ),
                      ),
                      DSSpacing.lg.y,
                      HubScreenIntro(
                        icon: Icons.forum_outlined,
                        message: clientCareTimelineIntroString,
                        iconColor: HubColors.seed,
                      ),
                      DSSpacing.md.y,
                      HubSectionHeader(
                        title: clientCareTimelineTitleString,
                        count: viewmodel.timeline.isEmpty
                            ? null
                            : viewmodel.timeline.length,
                      ),
                      DSSpacing.sm.y,
                      if (viewmodel.timeline.isEmpty)
                        HubSurface(
                          tint: HubColors.canvas,
                          child: HubEmptyState(
                            embedded: true,
                            icon: Icons.forum_outlined,
                            title: clientCareEmptyTitleString,
                            message: clientCareEmptyMessageString,
                          ),
                        )
                      else
                        ...viewmodel.timeline.map(
                          (entry) => HubTimelineEntryCard(
                            entry: entry,
                            timestampLabel: formatEncounterTimestamp(
                              entry.createdAt,
                            ),
                          ),
                        ),
                      DSSpacing.xl.y,
                    ],
                  ),
                ),
              ),
              _NoteComposer(
                controller: _noteController,
                isSaving: viewmodel.addNote.running,
                onSubmit: _submitNote,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ClientHeader extends StatelessWidget {
  const _ClientHeader({
    required this.clientName,
    required this.clientPhone,
    this.serviceType,
    this.onScheduleAppointment,
    this.onContactLaunchFailed,
  });

  final String clientName;
  final String clientPhone;
  final String? serviceType;
  final VoidCallback? onScheduleAppointment;
  final VoidCallback? onContactLaunchFailed;

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      padding: EdgeInsets.all(DSSpacing.md.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HubClientAvatar(
                initials: clientInitials(clientName),
                radius: 28,
              ),
              DSSpacing.md.x,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DSHeadlineSmallText(clientName, color: HubColors.ink),
                    if (clientPhone.trim().isNotEmpty) ...[
                      DSSpacing.xxs.y,
                      DSCaptionText(
                        formatBrPhone(clientPhone),
                        color: HubColors.inkMuted,
                      ),
                    ],
                    if (serviceType != null && serviceType!.trim().isNotEmpty) ...[
                      DSSpacing.xs.y,
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: HubColors.scheduleMuted,
                          borderRadius: BorderRadius.circular(DSSpacing.xs.value),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: DSSpacing.sm.value,
                            vertical: DSSpacing.xxs.value,
                          ),
                          child: DSCaptionSmallText(
                            serviceType!,
                            color: HubColors.schedule,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          DSSpacing.md.y,
          HubClientContactBar(
            clientPhone: clientPhone,
            onLaunchFailed: onContactLaunchFailed,
          ),
          if (onScheduleAppointment != null) ...[
            DSSpacing.md.y,
            HubSurface(
              onTap: onScheduleAppointment,
              semanticsLabel: clientCareScheduleAppointmentString,
              padding: EdgeInsets.symmetric(
                horizontal: DSSpacing.md.value,
                vertical: DSSpacing.sm.value,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_available_outlined,
                    size: 20,
                    color: HubColors.schedule,
                  ),
                  DSSpacing.sm.x,
                  Expanded(
                    child: DSBodyText(
                      clientCareScheduleAppointmentString,
                      fontWeight: FontWeight.w600,
                      color: HubColors.ink,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: HubColors.inkMuted,
                    size: 20,
                  ),
                ],
              ),
            ),
            DSSpacing.xxs.y,
            DSCaptionSmallText(
              clientCareScheduleAppointmentHintString,
              color: HubColors.inkMuted,
            ),
          ],
        ],
      ),
    );
  }
}

class _NoteComposer extends StatelessWidget {
  const _NoteComposer({
    required this.controller,
    required this.isSaving,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool isSaving;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HubColors.surface,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: HubColors.border),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(DSSpacing.md.value),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                DSCaptionText(
                  clientCareComposerHintString,
                  color: HubColors.inkMuted,
                ),
                DSSpacing.sm.y,
                HubTextFormField(
                  controller: controller,
                  label: clientCareNoteLabelString,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),
                DSSpacing.sm.y,
                HubPrimaryButton(
                  label: clientCareAddNoteString,
                  isLoading: isSaving,
                  onPressed: isSaving ? null : onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
