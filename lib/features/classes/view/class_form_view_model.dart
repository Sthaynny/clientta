import 'package:ufersa_hub/core/utils/commands.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/classes/domain/repositories/class_repository.dart';

class ClassFormViewModel {
  ClassFormViewModel({
    required ClassRepository repository,
    ClassEntry? initial,
  }) : _repository = repository,
       _initial = initial {
    save = CommandBase(_save);
  }

  final ClassRepository _repository;
  final ClassEntry? _initial;

  late final CommandBase<void> save;

  int weekday = DateTime.now().weekday;
  String subject = '';
  String startTime = '08:00';
  String endTime = '10:00';
  String room = '';
  String notes = '';

  void hydrate() {
    final entry = _initial;
    if (entry == null) return;
    weekday = entry.weekday;
    subject = entry.subject;
    startTime = entry.startTime;
    endTime = entry.endTime;
    room = entry.room ?? '';
    notes = entry.notes ?? '';
  }

  Future<Result<void>> _save() async {
    if (subject.trim().isEmpty) {
      return Result.errorDefault('Informe a disciplina.');
    }
    try {
      final id = _initial?.id ?? DateTime.now().microsecondsSinceEpoch.toString();
      await _repository.save(
        ClassEntry(
          id: id,
          weekday: weekday,
          subject: subject.trim(),
          startTime: startTime,
          endTime: endTime,
          room: room.trim().isEmpty ? null : room.trim(),
          notes: notes.trim().isEmpty ? null : notes.trim(),
        ),
      );
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
