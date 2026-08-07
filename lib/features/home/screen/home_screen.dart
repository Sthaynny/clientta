import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/client_care/domain/models/client_care_args.dart';
import 'package:clientta/features/home/screen/components/app_drawer.dart';
import 'package:clientta/features/home/screen/home_view_model.dart';
import 'package:clientta/features/shared/components/app_loading_widget.dart';
import 'package:clientta/features/shared/components/body_error_default_widget.dart';
import 'package:clientta/features/shared/hub/hub.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewmodel});

  final HomeViewModel viewmodel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with RouteAware, HubRouteRefreshMixin {
  HomeViewModel get viewmodel => widget.viewmodel;

  @override
  void initState() {
    super.initState();
    viewmodel.load.execute();
    viewmodel.markComplete.addListener(_onMarkComplete);
    viewmodel.cancelAppointment.addListener(_onCancelAppointment);
  }

  @override
  void dispose() {
    viewmodel.markComplete.removeListener(_onMarkComplete);
    viewmodel.cancelAppointment.removeListener(_onCancelAppointment);
    super.dispose();
  }

  @override
  void onHubRouteVisible() => viewmodel.load.execute();

  void _onMarkComplete() {
    if (!mounted) return;
    if (viewmodel.markComplete.completed) {
      context.showSnackBarSuccess(markCompleteSuccessString);
      viewmodel.markComplete.clearResult();
    } else if (viewmodel.markComplete.error) {
      context.showSnackBarError(errorSaveString);
      viewmodel.markComplete.clearResult();
    }
  }

  void _onCancelAppointment() {
    if (!mounted) return;
    if (viewmodel.cancelAppointment.completed) {
      context.showSnackBarSuccess(cancelAppointmentSuccessString);
      viewmodel.cancelAppointment.clearResult();
    } else if (viewmodel.cancelAppointment.error) {
      context.showSnackBarError(errorSaveString);
      viewmodel.cancelAppointment.clearResult();
    }
  }

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

  Future<void> _openRegisterAppointment() async {
    await context.go(AppRouters.appointmentForm);
    if (!mounted) return;
    viewmodel.load.execute();
  }

  Future<void> _confirmCancel(ServiceAppointment entry) async {
    final confirmed = await showHubConfirmDialog(
      context: context,
      title: cancelAppointmentTitleString,
      message: cancelAppointmentMessageString,
      confirmLabel: cancelAppointmentActionString,
      destructive: true,
    );
    if (confirmed == true && mounted) {
      await viewmodel.cancelAppointment.execute(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: HubAppBar(
        title: homeTodayString,
        leading: Builder(
          builder:
              (context) => IconButton(
                key: const Key('menu_button'),
                tooltip: menuString,
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu_rounded, size: 26),
              ),
        ),
      ),
      drawer: const AppDrawer(),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          viewmodel.load,
          if (viewmodel.syncService != null) viewmodel.syncService!,
        ]),
        builder: (context, _) {
          if (viewmodel.load.running && viewmodel.todayAppointments.isEmpty) {
            return const AppLoadingWidget();
          }
          if (viewmodel.load.error) {
            return BodyErrorDefaultWidget(
              title: errorLoadDailyString,
              onPressed: () => viewmodel.load.execute(),
            );
          }
          return RefreshIndicator(
            color: HubColors.seed,
            onRefresh: () async => viewmodel.load.execute(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(DSSpacing.md.value),
              children: [
                if (viewmodel.syncBannerState != HomeSyncBannerState.hidden) ...[
                  HubOfflineBanner(
                    message: switch (viewmodel.syncBannerState) {
                      HomeSyncBannerState.syncing => syncingBannerMessageString,
                      HomeSyncBannerState.syncPending =>
                        syncPendingBannerMessageString,
                      _ => offlineBannerMessageString,
                    },
                    variant:
                        viewmodel.syncBannerState ==
                                HomeSyncBannerState.offline
                            ? HubOfflineBannerVariant.offline
                            : HubOfflineBannerVariant.syncPending,
                  ),
                  DSSpacing.md.y,
                ],
                if (viewmodel.showSyncIndicator &&
                    viewmodel.lastSyncedAt != null) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: DSCaptionText(
                      formatLastSyncLabel(viewmodel.lastSyncedAt!),
                      color: HubColors.inkMuted,
                    ),
                  ),
                  DSSpacing.sm.y,
                ],
                HubDayHeader(
                  weekdayLabel: weekdayLabels[now.weekday - 1],
                  dateLabel: formatHubDayHeader(now),
                  appointmentsTodayCount: viewmodel.todayAppointments.length,
                ),
                DSSpacing.md.y,
                HubHomeQuickActions(
                  addAppointmentLabel: quickAddAppointmentString,
                  onAddAppointment: _openRegisterAppointment,
                ),
                DSSpacing.lg.y,
                HubHomeSection(
                  title: appointmentsTodayString,
                  count: viewmodel.todayAppointments.isEmpty
                      ? null
                      : viewmodel.todayAppointments.length,
                  actionLabel: myAgendaString,
                  onAction: () =>
                      Navigator.of(context).pushReplacementNamed(
                        AppRouters.agendas.path,
                      ),
                  child: viewmodel.todayAppointments.isEmpty
                      ? HubEmptyState(
                          embedded: true,
                          icon: Icons.event_note_outlined,
                          title: emptyAppointmentsHomeTitle,
                          message: emptyAppointmentsHomeMessage,
                          actionLabel: addAppointmentString,
                          onAction: _openRegisterAppointment,
                        )
                      : Column(
                          children:
                              viewmodel.todayAppointments
                                  .map(_appointmentTile)
                                  .toList(),
                        ),
                ),
                DSSpacing.xl.y,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _appointmentTile(ServiceAppointment entry) {
    return HubAppointmentCard(
      clientName: entry.clientName,
      clientPhone: entry.clientPhone,
      serviceType: entry.serviceType,
      startTime: entry.startTime,
      endTime: entry.endTime,
      status: entry.status,
      notes: entry.notes,
      onTap: () => _openClientCare(entry),
      onMarkComplete:
          entry.status == AppointmentStatus.agendado.value
              ? () => viewmodel.markComplete.execute(entry)
              : null,
      onAddNotes: () => _openClientCare(entry),
      onViewCare: () => _openClientCare(entry),
      onCancel:
          entry.status == AppointmentStatus.agendado.value
              ? () => _confirmCancel(entry)
              : null,
    );
  }
}
