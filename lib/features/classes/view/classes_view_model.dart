import 'package:ufersa_hub/core/utils/commands.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/classes/domain/repositories/class_repository.dart';

class ClassesViewModel {
  ClassesViewModel({required ClassRepository repository})
    : _repository = repository {
    load = CommandBase(_load);
    deleteEntry = CommandAction<void, String>(_delete);
  }

  final ClassRepository _repository;
  late final CommandBase<void> load;
  late final CommandAction<void, String> deleteEntry;

  List<ClassEntry> entries = [];

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
}
