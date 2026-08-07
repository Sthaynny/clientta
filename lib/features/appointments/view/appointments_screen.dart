import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/view/appointments_view_model.dart';
import 'package:clientta/features/client_care/domain/models/client_care_args.dart';
import 'package:clientta/features/shared/components/app_loading_widget.dart';
import 'package:clientta/features/shared/components/body_error_default_widget.dart';
import 'package:clientta/features/shared/hub/hub.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key, required this.viewmodel});

  final AppointmentsViewModel viewmodel;

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with RouteAware, HubRouteRefreshMixin {
  AppointmentsViewModel get viewmodel => widget.viewmodel;
  String? _serviceTypeFilter;

  @override
  void initState() {
    super.initState();
    viewmodel.load.execute();
  }

  @override
  void onHubRouteVisible() => viewmodel.load.execute();

  Future<void> _openClientCare(ServiceAppointment entry) async {
    await context.go(
      AppRouters.clientCare,
      arguments: ClientCareArgs(
        clientName: entry.clientName,
        clientPhone: entry.clientPhone,
        serviceType: entry.serviceType,
        appointmentId: entry.id,
      ),
    );
    if (!mounted) return;
    viewmodel.load.execute();
  }

  Future<void> _openAppointmentForm({ServiceAppointment? entry}) async {
    await context.go(AppRouters.appointmentForm, arguments: entry);
    if (!mounted) return;
    viewmodel.load.execute();
  }

  Future<void> _confirmDelete(ServiceAppointment entry) async {
    final seriesId = entry.seriesId;
    if (seriesId != null && seriesId.isNotEmpty) {
      final choice = await showHubChoiceDialog(
        context: context,
        title: deleteSeriesTitleString,
        message: deleteSeriesMessageString,
        firstLabel: deleteSeriesOneLabelString,
        secondLabel: deleteSeriesAllLabelString,
        secondDestructive: true,
      );
      if (!mounted || choice == HubChoiceResult.cancelled) return;

      await viewmodel.deleteEntry.execute(
        DeleteAppointmentRequest(
          id: entry.id,
          seriesId: seriesId,
          deleteEntireSeries: choice == HubChoiceResult.second,
        ),
      );
      return;
    }

    final confirmed = await showHubConfirmDialog(
      context: context,
      title: deleteAppointmentTitleString,
      message: deleteAppointmentMessageString,
      confirmLabel: deleteString,
    );
    if (confirmed == true && mounted) {
      await viewmodel.deleteEntry.execute(
        DeleteAppointmentRequest(id: entry.id),
      );
    }
  }

  Widget _buildFilterBar() {
    final types = viewmodel.availableServiceTypes();
    if (types.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: DSSpacing.md.value),
      child: DropdownButtonFormField<String?>(
        key: ValueKey(_serviceTypeFilter),
        initialValue: _serviceTypeFilter,
        decoration: InputDecoration(
          labelText: filterServiceTypeLabelString,
        ),
        items: [
          DropdownMenuItem<String?>(
            value: null,
            child: Text(filterAllServiceTypesString),
          ),
          ...types.map(
            (type) => DropdownMenuItem<String?>(
              value: type,
              child: Text(type),
            ),
          ),
        ],
        onChanged: (value) => setState(() => _serviceTypeFilter = value),
      ),
    );
  }

  Widget _buildGroupedList() {
    final groups = viewmodel.groupedEntries(_serviceTypeFilter);
    final totalCount = viewmodel.filteredEntries(_serviceTypeFilter).length;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(DSSpacing.md.value),
      itemCount: groups.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HubSectionHeader(
                title: myAgendaString,
                count: totalCount,
              ),
              _buildFilterBar(),
            ],
          );
        }

        final group = groups[index - 1];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HubSectionHeader(
              title: group.title,
              count: group.entries.length,
            ),
            if (group.subtitle != null)
              Padding(
                padding: EdgeInsets.only(bottom: DSSpacing.sm.value),
                child: DSCaptionText(
                  group.subtitle!,
                  color: HubColors.inkMuted,
                ),
              ),
            ...group.entries.map(
              (entry) => HubAppointmentCard(
                clientName: entry.clientName,
                clientPhone: entry.clientPhone,
                serviceType: entry.serviceType,
                startTime: entry.startTime,
                endTime: entry.endTime,
                status: entry.status,
                notes: entry.notes,
                onTap: () => _openClientCare(entry),
                onViewCare: () => _openClientCare(entry),
                onEdit: () => _openAppointmentForm(entry: entry),
                onDelete: () => _confirmDelete(entry),
              ),
            ),
            DSSpacing.sm.y,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        title: myAgendaString,
        showBrandMark: false,
        onBackButtonPressed:
            () => Navigator.of(context).pushReplacementNamed(
              AppRouters.home.path,
            ),
      ),
      floatingActionButton: HubFab(
        label: addAppointmentString,
        onPressed: () => _openAppointmentForm(),
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

          Future<void> onRefresh() async => viewmodel.load.execute();
          final hasFilteredEntries =
              viewmodel.filteredEntries(_serviceTypeFilter).isNotEmpty;

          if (viewmodel.entries.isEmpty) {
            return RefreshIndicator(
              color: HubColors.seed,
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.65,
                  child: HubEmptyState(
                    icon: Icons.event_note_outlined,
                    title: emptyAgendaTitle,
                    message: emptyAgendaMessage,
                    actionLabel: addAppointmentString,
                    onAction: () => _openAppointmentForm(),
                  ),
                ),
              ),
            );
          }

          if (!hasFilteredEntries) {
            return RefreshIndicator(
              color: HubColors.seed,
              onRefresh: onRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(DSSpacing.md.value),
                children: [
                  HubSectionHeader(
                    title: myAgendaString,
                    count: 0,
                  ),
                  _buildFilterBar(),
                  DSSpacing.lg.y,
                  HubEmptyState(
                    embedded: true,
                    icon: Icons.filter_list_off_outlined,
                    title: filterEmptyTitleString,
                    message: filterEmptyMessageString,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: HubColors.seed,
            onRefresh: onRefresh,
            child: _buildGroupedList(),
          );
        },
      ),
    );
  }
}
