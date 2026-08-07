import 'package:flutter/widgets.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/view/appointment_form_screen.dart';
import 'package:clientta/features/appointments/view/appointment_form_view_model.dart';
import 'package:clientta/features/appointments/view/appointments_screen.dart';
import 'package:clientta/features/billing/view/plan_settings_screen.dart';
import 'package:clientta/features/home/screen/home_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  AppRouters.home.path: (context) => HomeScreen(viewmodel: dependency()),
  AppRouters.agendas.path: (context) => AppointmentsScreen(viewmodel: dependency()),
  AppRouters.appointmentForm.path: (context) {
    final entry =
        ModalRoute.of(context)?.settings.arguments as ServiceAppointment?;
    return AppointmentFormScreen(
      viewmodel: AppointmentFormViewModel(
        repository: dependency(),
        initial: entry,
      ),
      isEdit: entry != null,
    );
  },
  AppRouters.planSettings.path: (context) => const PlanSettingsScreen(),
};

enum AppRouters {
  home,
  agendas,
  appointmentForm,
  planSettings;

  const AppRouters();

  String get path => switch (this) {
    home => '/',
    agendas => '/agendas',
    appointmentForm => '/agendas/registrar',
    planSettings => '/plano',
  };
}
