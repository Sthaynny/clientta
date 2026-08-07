import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/view/appointments_view_model.dart';
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

  @override
  void initState() {
    super.initState();
    viewmodel.load.execute();
  }

  @override
  void onHubRouteVisible() => viewmodel.load.execute();

  Future<void> _openAppointmentForm({ServiceAppointment? entry}) async {
    await context.go(AppRouters.appointmentForm, arguments: entry);
    if (!mounted) return;
    viewmodel.load.execute();
  }

  Future<void> _confirmDelete(ServiceAppointment entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(deleteAppointmentTitleString),
            content: Text(deleteAppointmentMessageString),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelString),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(deleteString),
              ),
            ],
          ),
    );
    if (confirmed == true && mounted) {
      await viewmodel.deleteEntry.execute(entry.id);
    }
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

          return RefreshIndicator(
            color: HubColors.seed,
            onRefresh: onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(DSSpacing.md.value),
              itemCount: viewmodel.entries.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: DSSpacing.sm.value),
                    child: HubSectionHeader(
                      title: myAgendaString,
                      count: viewmodel.entries.length,
                    ),
                  );
                }
                final entry = viewmodel.entries[index - 1];
                return HubAppointmentCard(
                  clientName: entry.clientName,
                  serviceType: entry.serviceType,
                  startTime: entry.startTime,
                  endTime: entry.endTime,
                  status: entry.status,
                  onTap: () => _openAppointmentForm(entry: entry),
                  onEdit: () => _openAppointmentForm(entry: entry),
                  onDelete: () => _confirmDelete(entry),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
