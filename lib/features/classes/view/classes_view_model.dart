import 'package:university_hub/core/utils/commands.dart';
import 'package:university_hub/core/utils/result.dart';
import 'package:university_hub/features/classes/domain/models/class_entry.dart';
import 'package:university_hub/features/classes/domain/models/class_schedule_group.dart';
import 'package:university_hub/features/classes/domain/repositories/class_repository.dart';

class ClassesViewModel {
  ClassesViewModel({required ClassRepository repository})
    : _repository = repository {
    load = CommandBase(_load);
    deleteGroup = CommandAction<void, List<String>>(_deleteGroup);
  }

  final ClassRepository _repository;
  late final CommandBase<void> load;
  late final CommandAction<void, List<String>> deleteGroup;

  List<ClassEntry> entries = [];
  List<ClassScheduleGroup> groups = [];

  Future<Result<void>> _load() async {
    try {
      entries = await _repository.getAll();
      groups = ClassScheduleGroup.fromEntries(entries);
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _deleteGroup(List<String> ids) async {
    if (ids.isEmpty) return Result.ok();
    try {
      await _repository.saveAll(const [], deleteIds: ids);
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
