import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
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
  }

  @override
  void onHubRouteVisible() => viewmodel.load.execute();

  Future<void> _openAppointmentForm({ServiceAppointment? entry}) async {
    await context.go(AppRouters.appointmentForm, arguments: entry);
    if (!mounted) return;
    viewmodel.load.execute();
  }

  Future<void> _showQuickNotes(ServiceAppointment entry) async {
    final controller = TextEditingController(text: entry.notes ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(quickNotesDialogTitleString),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: quickNotesDialogHintString,
              ),
              maxLines: 3,
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(cancelString),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(saveString),
              ),
            ],
          ),
    );
    if (saved == true && mounted) {
      await viewmodel.updateNotes.execute(
        QuickNotesInput(appointment: entry, notes: controller.text),
      );
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
        listenable: viewmodel.load,
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
                HubDayHeader(
                  weekdayLabel: weekdayLabels[now.weekday - 1],
                  dateLabel: formatHubDayHeader(now),
                  appointmentsTodayCount: viewmodel.todayAppointments.length,
                ),
                DSSpacing.md.y,
                HubHomeQuickActions(
                  addAppointmentLabel: quickAddAppointmentString,
                  onAddAppointment: () => _openAppointmentForm(),
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
                          onAction: () => _openAppointmentForm(),
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
      serviceType: entry.serviceType,
      startTime: entry.startTime,
      endTime: entry.endTime,
      status: entry.status,
      onTap: () => _openAppointmentForm(entry: entry),
      onMarkComplete:
          entry.status == AppointmentStatus.agendado.value
              ? () => viewmodel.markComplete.execute(entry)
              : null,
      onAddNotes: () => _showQuickNotes(entry),
    );
  }
}
