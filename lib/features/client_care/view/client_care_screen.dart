import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/client_care/domain/models/care_timeline_entry.dart';
import 'package:clientta/features/client_care/view/client_care_view_model.dart';
import 'package:clientta/features/shared/components/app_loading_widget.dart';
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
      context.showSnackBarSuccess(encounterNoteSavedString);
      viewmodel.addNote.clearResult();
    } else if (viewmodel.addNote.error) {
      context.showSnackBarError(errorSaveString);
      viewmodel.addNote.clearResult();
    }
  }

  Future<void> _submitNote() async {
    await viewmodel.addNote.execute(_noteController.text);
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
            return const AppLoadingWidget();
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
                      ),
                      DSSpacing.lg.y,
                      HubSectionHeader(
                        title: clientCareTimelineTitleString,
                        count: viewmodel.timeline.isEmpty
                            ? null
                            : viewmodel.timeline.length,
                      ),
                      DSSpacing.sm.y,
                      if (viewmodel.timeline.isEmpty)
                        HubEmptyState(
                          embedded: true,
                          icon: Icons.forum_outlined,
                          title: clientCareEmptyTitleString,
                          message: clientCareEmptyMessageString,
                        )
                      else
                        ...viewmodel.timeline.map(_timelineTile),
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

  Widget _timelineTile(CareTimelineEntry entry) {
    return Padding(
      padding: EdgeInsets.only(bottom: DSSpacing.sm.value),
      child: HubSurface(
        padding: EdgeInsets.all(DSSpacing.md.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: DSCaptionText(
                    formatEncounterTimestamp(entry.createdAt),
                    color: HubColors.inkMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (entry.source == CareTimelineSource.appointment)
                  _SourceBadge(label: clientCareFromAppointmentString),
              ],
            ),
            if (entry.contextLabel != null) ...[
              DSSpacing.xxs.y,
              DSCaptionSmallText(
                entry.contextLabel!,
                color: HubColors.inkMuted,
              ),
            ],
            if (entry.serviceType != null) ...[
              DSSpacing.xxs.y,
              DSCaptionSmallText(
                entry.serviceType!,
                color: HubColors.inkMuted,
              ),
            ],
            DSSpacing.xs.y,
            DSBodyText(
              entry.body,
              color: HubColors.ink,
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientHeader extends StatelessWidget {
  const _ClientHeader({
    required this.clientName,
    required this.clientPhone,
    this.serviceType,
  });

  final String clientName;
  final String clientPhone;
  final String? serviceType;

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      padding: EdgeInsets.all(DSSpacing.md.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DSHeadlineSmallText(clientName, color: HubColors.ink),
          if (clientPhone.trim().isNotEmpty) ...[
            DSSpacing.xxs.y,
            DSCaptionText(clientPhone, color: HubColors.inkMuted),
          ],
          if (serviceType != null && serviceType!.trim().isNotEmpty) ...[
            DSSpacing.xs.y,
            DSCaptionText(serviceType!, color: HubColors.schedule),
          ],
        ],
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
          label,
          color: HubColors.schedule,
          fontWeight: FontWeight.w700,
        ),
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
      elevation: 8,
      color: HubColors.surface,
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
    );
  }
}
