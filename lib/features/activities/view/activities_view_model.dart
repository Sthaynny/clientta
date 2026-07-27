import 'package:university_hub/core/utils/commands.dart';
import 'package:university_hub/core/utils/result.dart';
import 'package:university_hub/features/activities/domain/models/activity_entry.dart';
import 'package:university_hub/features/activities/domain/repositories/activity_repository.dart';

class ActivitiesViewModel {
  ActivitiesViewModel({required ActivityRepository repository})
    : _repository = repository {
    load = CommandBase(_load);
    deleteEntry = CommandAction<void, String>(_delete);
    toggleDone = CommandAction<void, ActivityEntry>(_toggle);
  }

  final ActivityRepository _repository;
  late final CommandBase<void> load;
  late final CommandAction<void, String> deleteEntry;
  late final CommandAction<void, ActivityEntry> toggleDone;

  List<ActivityEntry> entries = [];

  Future<Result<void>> _load() async {
    try {
      entries = await _repository.getAll();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _delete(String id) async {
    try {
      await _repository.delete(id);
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _toggle(ActivityEntry entry) async {
    try {
      await _repository.save(entry.copyWith(done: !entry.done));
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
