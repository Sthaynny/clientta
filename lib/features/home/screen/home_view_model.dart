import 'package:ufersa_hub/core/utils/commands.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/activities/domain/models/activity_entry.dart';
import 'package:ufersa_hub/features/activities/domain/repositories/activity_repository.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/classes/domain/repositories/class_repository.dart';

class HomeViewModel {
  HomeViewModel({
    required ClassRepository classRepository,
    required ActivityRepository activityRepository,
  }) : _classRepository = classRepository,
       _activityRepository = activityRepository {
    load = CommandBase(_load);
    toggleActivity = CommandAction<void, ActivityEntry>(_toggleActivity);
  }

  final ClassRepository _classRepository;
  final ActivityRepository _activityRepository;

  late final CommandBase<void> load;
  late final CommandAction<void, ActivityEntry> toggleActivity;

  List<ClassEntry> todayClasses = [];
  List<ActivityEntry> todayActivities = [];

  Future<Result<void>> _load() async {
    try {
      final now = DateTime.now();
      final weekday = now.weekday;
      final classes = await _classRepository.getAll();
      todayClasses = classes.where((c) => c.weekday == weekday).toList();

      final activities = await _activityRepository.getAll();
      todayActivities =
          activities
              .where(
                (a) =>
                    a.date.year == now.year &&
                    a.date.month == now.month &&
                    a.date.day == now.day,
              )
              .toList()
            ..sort((a, b) => a.done == b.done ? 0 : (a.done ? 1 : -1));

      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _toggleActivity(ActivityEntry entry) async {
    try {
      final updated = entry.copyWith(done: !entry.done);
      await _activityRepository.save(updated);
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
