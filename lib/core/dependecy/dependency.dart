import 'package:get_it/get_it.dart';
import 'package:clientta/core/backup/data_backup_service.dart';
import 'package:clientta/core/router/app_navigator.dart';
import 'package:clientta/core/network/network_status_port.dart';
import 'package:clientta/core/network/network_status_service.dart';
import 'package:clientta/core/storage/app_profile_repository.dart';
import 'package:clientta/core/storage/device_json_store.dart';
import 'package:clientta/features/auth/data/auth_repository_firebase.dart';
import 'package:clientta/features/auth/data/user_repository_remote.dart';
import 'package:clientta/features/auth/domain/repositories/auth_repository.dart';
import 'package:clientta/features/auth/domain/repositories/user_repository.dart';
import 'package:clientta/features/appointments/data/appointment_reminder_coordinator.dart';
import 'package:clientta/features/appointments/data/appointment_repository_local.dart';
import 'package:clientta/features/appointments/data/local_appointment_reminder_scheduler.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_scheduler.dart';
import 'package:clientta/features/appointments/data/service_type_catalog_local.dart';
import 'package:clientta/features/appointments/data/appointment_repository_remote_firestore.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository_remote.dart';
import 'package:clientta/features/appointments/view/appointments_view_model.dart';
import 'package:clientta/features/client_care/data/encounter_note_repository_local.dart';
import 'package:clientta/features/client_care/data/encounter_note_repository_remote_firestore.dart';
import 'package:clientta/features/client_care/domain/repositories/encounter_note_repository.dart';
import 'package:clientta/features/client_care/domain/repositories/encounter_note_repository_remote.dart';
import 'package:clientta/features/billing/data/datasources/firebase_billing_datasource.dart';
import 'package:clientta/features/billing/data/repositories/billing_repository_impl.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';
import 'package:clientta/features/clients/view/clients_view_model.dart';
import 'package:clientta/features/home/screen/home_view_model.dart';

final dependency = GetIt.instance;

void setup() {
  dependency.registerLazySingleton<DeviceJsonStore>(DeviceJsonStore.new);

  dependency.registerLazySingleton<AppProfileRepository>(
    () => AppProfileRepository(dependency()),
  );

  dependency.registerLazySingleton<DataBackupService>(
    () => DataBackupService(
      store: dependency(),
      billingRepository: dependency(),
    ),
  );

  dependency.registerLazySingleton<AuthRepository>(
    AuthRepositoryFirebase.new,
  );
  dependency.registerLazySingleton<UserRepository>(
    UserRepositoryRemote.new,
  );

  dependency.registerLazySingleton<NetworkStatusPort>(
    () => const NetworkStatusService(),
  );

  dependency.registerLazySingleton<AppointmentRepositoryLocal>(
    () => AppointmentRepositoryLocal(dependency()),
  );

  dependency.registerLazySingleton<ServiceTypeCatalogLocal>(
    () => ServiceTypeCatalogLocal(dependency()),
  );

  dependency.registerLazySingleton<AppointmentRepository>(
    () => dependency<AppointmentRepositoryLocal>(),
  );

  dependency.registerLazySingleton<AppointmentRepositoryRemote>(
    AppointmentRepositoryRemoteFirestore.new,
  );

  dependency.registerLazySingleton<AppointmentSyncService>(
    () => AppointmentSyncService(
      store: dependency(),
      localRepository: dependency(),
      remoteRepository: dependency(),
      encounterNoteLocalRepository: dependency(),
      encounterNoteRemoteRepository: dependency(),
      userRepository: dependency(),
    ),
  );

  dependency.registerLazySingleton<AppointmentReminderScheduler>(
    () => createLocalAppointmentReminderScheduler(
      onNotificationTap: AppNavigator.handleReminderNotificationPayload,
    ),
  );
  dependency.registerLazySingleton<AppointmentReminderCoordinator>(
    () => AppointmentReminderCoordinator(
      scheduler: dependency(),
      billingRepository: dependency(),
      appProfileRepository: dependency(),
    ),
  );

  dependency.registerLazySingleton<EncounterNoteRepositoryLocal>(
    () => EncounterNoteRepositoryLocal(dependency()),
  );

  dependency.registerLazySingleton<EncounterNoteRepositoryRemote>(
    EncounterNoteRepositoryRemoteFirestore.new,
  );

  dependency.registerLazySingleton<EncounterNoteRepository>(
    () => dependency<EncounterNoteRepositoryLocal>(),
  );

  dependency.registerLazySingleton<FirebaseBillingDatasource>(
    FirebaseBillingDatasource.new,
  );
  dependency.registerLazySingleton<BillingRepository>(
    () => BillingRepositoryImpl(dependency()),
  );

  dependency.registerFactory(
    () => HomeViewModel(
      appointmentRepository: dependency(),
      networkStatus: dependency(),
      syncService: dependency(),
      reminderCoordinator: dependency(),
      hasProSync: () => dependency<AppointmentSyncService>().canSync(),
    ),
  );
  dependency.registerFactory(
    () => AppointmentsViewModel(
      repository: dependency(),
      billingRepository: dependency(),
      syncService: dependency(),
      reminderCoordinator: dependency(),
    ),
  );
  dependency.registerFactory(
    () => ClientsViewModel(
      appointmentRepository: dependency(),
      encounterRepository: dependency(),
      syncService: dependency(),
    ),
  );
}
