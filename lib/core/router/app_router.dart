import 'package:flutter/widgets.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/features/appointments/domain/models/appointment_form_launch_args.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/view/appointment_form_screen.dart';
import 'package:clientta/features/appointments/view/appointment_form_view_model.dart';
import 'package:clientta/features/appointments/view/appointments_screen.dart';
import 'package:clientta/features/billing/view/plan_settings_screen.dart';
import 'package:clientta/features/client_care/domain/models/client_care_args.dart';
import 'package:clientta/features/clients/view/clients_screen.dart';
import 'package:clientta/features/client_care/view/client_care_screen.dart';
import 'package:clientta/features/client_care/view/client_care_view_model.dart';
import 'package:clientta/features/home/screen/home_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  AppRouters.home.path: (context) => HomeScreen(viewmodel: dependency()),
  AppRouters.agendas.path: (context) => AppointmentsScreen(viewmodel: dependency()),
  AppRouters.clients.path: (context) => ClientsScreen(viewmodel: dependency()),
  AppRouters.appointmentForm.path: (context) {
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    ServiceAppointment? editEntry;
    String? prefillClientName;
    String? prefillClientPhone;
    String? prefillServiceType;
    var lockClientFields = false;

    if (rawArgs is ServiceAppointment) {
      editEntry = rawArgs;
    } else if (rawArgs is AppointmentFormLaunchArgs) {
      editEntry = rawArgs.editEntry;
      prefillClientName = rawArgs.prefillClientName;
      prefillClientPhone = rawArgs.prefillClientPhone;
      prefillServiceType = rawArgs.prefillServiceType;
      lockClientFields = rawArgs.lockClientFields;
    }

    return AppointmentFormScreen(
      viewmodel: AppointmentFormViewModel(
        repository: dependency(),
        billingRepository: dependency(),
        serviceTypeCatalog: dependency(),
        userRepository: dependency(),
        syncService: dependency(),
        reminderCoordinator: dependency(),
        appProfileRepository: dependency(),
        initial: editEntry,
        prefillClientName: prefillClientName,
        prefillClientPhone: prefillClientPhone,
        prefillServiceType: prefillServiceType,
        lockClientFields: lockClientFields,
      ),
      isEdit: editEntry != null,
    );
  },
  AppRouters.planSettings.path: (context) => const PlanSettingsScreen(),
  AppRouters.clientCare.path: (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as ClientCareArgs;
    return ClientCareScreen(
      viewmodel: ClientCareViewModel(
        encounterRepository: dependency(),
        syncService: dependency(),
        args: args,
      ),
    );
  },
};

enum AppRouters {
  home,
  agendas,
  clients,
  appointmentForm,
  clientCare,
  planSettings;

  const AppRouters();

  String get path => switch (this) {
    home => '/',
    agendas => '/agendas',
    clients => '/clientes',
    appointmentForm => '/agendas/registrar',
    clientCare => '/atendimentos',
    planSettings => '/plano',
  };
}

/// Public auth routes (outside [MyApp] — gated by [AuthGate]).
enum AuthRouters {
  login,
  register;

  const AuthRouters();

  String get path => switch (this) {
    login => '/login',
    register => '/cadastro',
  };
}
