import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/plan/plan_access_policy.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/view/appointments_view_model.dart';
import 'package:clientta/features/billing/domain/subscription_session.dart';
import 'package:clientta/features/client_care/domain/models/client_care_args.dart';
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
  late final SubscriptionSession _subscriptionSession;

  @override
  void initState() {
    super.initState();
    _subscriptionSession = dependency<SubscriptionSession>();
    _subscriptionSession.addListener(_onSubscriptionChanged);
    viewmodel.load.execute();
  }

  @override
  void dispose() {
    _subscriptionSession.removeListener(_onSubscriptionChanged);
    super.dispose();
  }

  void _onSubscriptionChanged() {
    if (!mounted) return;
    viewmodel.applySessionSubscription();
    setState(() {});
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
    if (entry == null && viewmodel.isAtAppointmentLimit) {
      context.showSnackBarWarning(
        planFreeLimitAppointmentsMessage(
          PlanAccessPolicy.freeMaxActiveAppointments,
        ),
      );
      return;
    }

    await context.go(AppRouters.appointmentForm, arguments: entry);
    if (!mounted) return;
    viewmodel.load.execute();
  }

  Widget _buildPlanUsageBanner() {
    if (!viewmodel.showPlanUsageBanner) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: DSSpacing.md.value),
      child: HubPlanUsageBanner(
        activeAppointments: viewmodel.activeAppointmentsCount,
        activeSeries: viewmodel.activeSeriesCount,
      ),
    );
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

  Widget _buildScreenIntro() {
    return Padding(
      padding: EdgeInsets.only(bottom: DSSpacing.md.value),
      child: HubScreenIntro(
        icon: Icons.event_note_outlined,
        message: agendaScreenIntroString,
        iconColor: HubColors.schedule,
      ),
    );
  }

  Widget _buildFilterBar() {
    final types = viewmodel.availableServiceTypes();
    if (types.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: DSSpacing.md.value),
      child: HubServiceTypeFilter(
        label: filterServiceTypeLabelString,
        allLabel: filterAllServiceTypesString,
        types: types,
        selected: _serviceTypeFilter,
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
              _buildPlanUsageBanner(),
              _buildScreenIntro(),
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
            return const HubAppointmentListLoadingSkeleton(
              showIntro: true,
              showFilter: true,
            );
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
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(DSSpacing.md.value),
                children: [
                  _buildPlanUsageBanner(),
                  _buildScreenIntro(),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.42,
                    child: HubEmptyState(
                      useSurface: true,
                      icon: Icons.event_note_outlined,
                      title: emptyAgendaTitle,
                      message: emptyAgendaMessage,
                      actionLabel: addAppointmentString,
                      onAction: () => _openAppointmentForm(),
                    ),
                  ),
                ],
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
                  _buildPlanUsageBanner(),
                  _buildScreenIntro(),
                  HubSectionHeader(
                    title: myAgendaString,
                    count: 0,
                  ),
                  _buildFilterBar(),
                  DSSpacing.lg.y,
                  HubEmptyState(
                    embedded: true,
                    useSurface: true,
                    icon: Icons.filter_list_off_outlined,
                    title: filterEmptyTitleString,
                    message: filterEmptyMessageString,
                    actionLabel: filterClearActionString,
                    onAction: () => setState(() => _serviceTypeFilter = null),
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
