import 'package:get_it/get_it.dart';
import 'package:clientta/core/storage/app_profile_repository.dart';
import 'package:clientta/core/storage/device_json_store.dart';
import 'package:clientta/features/appointments/data/appointment_repository_local.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/appointments/view/appointments_view_model.dart';
import 'package:clientta/features/billing/data/datasources/firebase_billing_datasource.dart';
import 'package:clientta/features/billing/data/repositories/billing_repository_impl.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';
import 'package:clientta/features/home/screen/home_view_model.dart';

final dependency = GetIt.instance;

void setup() {
  dependency.registerLazySingleton<DeviceJsonStore>(DeviceJsonStore.new);

  dependency.registerLazySingleton<AppProfileRepository>(
    () => AppProfileRepository(dependency()),
  );

  dependency.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryLocal(dependency()),
  );

  dependency.registerLazySingleton<FirebaseBillingDatasource>(
    FirebaseBillingDatasource.new,
  );
  dependency.registerLazySingleton<BillingRepository>(
    () => BillingRepositoryImpl(dependency()),
  );

  dependency.registerFactory(
    () => HomeViewModel(appointmentRepository: dependency()),
  );
  dependency.registerFactory(
    () => AppointmentsViewModel(repository: dependency()),
  );
}
