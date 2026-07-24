import 'package:ufersa_hub/core/utils/commands.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/activities/domain/models/activity_entry.dart';
import 'package:ufersa_hub/features/activities/domain/repositories/activity_repository.dart';

class ActivityFormViewModel {
  ActivityFormViewModel({
    required ActivityRepository repository,
    ActivityEntry? initial,
  }) : _repository = repository,
       _initial = initial {
    save = CommandBase(_save);
  }

  final ActivityRepository _repository;
  final ActivityEntry? _initial;

  late final CommandBase<void> save;

  String title = '';
  DateTime date = DateTime.now();
  ActivityKind kind = ActivityKind.estudo;
  bool done = false;
  String notes = '';

  void hydrate() {
    final entry = _initial;
    if (entry == null) return;
    title = entry.title;
    date = entry.date;
    kind = entry.kind;
    done = entry.done;
    notes = entry.notes ?? '';
  }

  Future<Result<void>> _save() async {
    if (title.trim().isEmpty) {
      return Result.errorDefault('Descreva a atividade.');
    }
    try {
      final id = _initial?.id ?? DateTime.now().microsecondsSinceEpoch.toString();
      await _repository.save(
        ActivityEntry(
          id: id,
          title: title.trim(),
          date: DateTime(date.year, date.month, date.day),
          kind: kind,
          done: done,
          notes: notes.trim().isEmpty ? null : notes.trim(),
        ),
      );
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
