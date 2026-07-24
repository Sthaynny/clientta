import 'package:get_it/get_it.dart';
import 'package:ufersa_hub/core/storage/device_json_store.dart';
import 'package:ufersa_hub/features/activities/data/activity_repository_local.dart';
import 'package:ufersa_hub/features/activities/domain/repositories/activity_repository.dart';
import 'package:ufersa_hub/features/activities/view/activities_view_model.dart';
import 'package:ufersa_hub/features/classes/data/class_repository_local.dart';
import 'package:ufersa_hub/features/classes/domain/repositories/class_repository.dart';
import 'package:ufersa_hub/features/classes/view/classes_view_model.dart';
import 'package:ufersa_hub/features/home/screen/home_view_model.dart';

final dependency = GetIt.instance;

void setup() {
  dependency.registerLazySingleton<DeviceJsonStore>(DeviceJsonStore.new);

  dependency.registerLazySingleton<ClassRepository>(
    () => ClassRepositoryLocal(dependency()),
  );
  dependency.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryLocal(dependency()),
  );

  dependency.registerFactory(
    () => HomeViewModel(
      classRepository: dependency(),
      activityRepository: dependency(),
    ),
  );
  dependency.registerFactory(() => ClassesViewModel(repository: dependency()));
  dependency.registerFactory(
    () => ActivitiesViewModel(repository: dependency()),
  );
}
