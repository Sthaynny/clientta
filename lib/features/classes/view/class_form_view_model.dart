import 'package:ufersa_hub/core/utils/commands.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/classes/domain/class_form_validation.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/classes/domain/repositories/class_repository.dart';

class ClassFormViewModel {
  ClassFormViewModel({
    required ClassRepository repository,
    ClassEntry? initial,
  }) : _repository = repository,
       _initial = initial {
    save = CommandBase(_save);
    selectedWeekdays = {DateTime.now().weekday};
  }

  final ClassRepository _repository;
  final ClassEntry? _initial;

  late final CommandBase<void> save;

  late Set<int> selectedWeekdays;
  String subject = '';
  String startTime = '08:00';
  String endTime = '10:00';
  String room = '';
  String notes = '';

  List<ClassEntry> _loadedEntries = [];
  String? _seriesId;

  Future<void> hydrate() async {
    final entry = _initial;
    if (entry == null) return;

    subject = entry.subject;
    startTime = entry.startTime;
    endTime = entry.endTime;
    room = entry.room ?? '';
    notes = entry.notes ?? '';

    final seriesId = entry.seriesId;
    if (seriesId != null && seriesId.isNotEmpty) {
      _seriesId = seriesId;
      _loadedEntries = await _repository.getBySeriesId(seriesId);
      if (_loadedEntries.isEmpty) {
        _loadedEntries = [entry];
      }
    } else {
      _seriesId = null;
      _loadedEntries = [entry];
    }

    selectedWeekdays = _loadedEntries.map((e) => e.weekday).toSet();
  }

  void toggleWeekdays(Set<int> weekdays) {
    selectedWeekdays = weekdays;
  }

  Future<Result<void>> _save() async {
    final validation = validateClassForm(
      selectedWeekdays: selectedWeekdays,
      subject: subject,
      startTime: startTime,
      endTime: endTime,
    );
    if (validation.isError) return validation;

    try {
      final trimmedSubject = subject.trim();
      final trimmedRoom = room.trim();
      final trimmedNotes = notes.trim();
      final roomValue = trimmedRoom.isEmpty ? null : trimmedRoom;
      final notesValue = trimmedNotes.isEmpty ? null : trimmedNotes;
      final trimmedStart = startTime.trim();
      final trimmedEnd = endTime.trim();

      final useSeries = selectedWeekdays.length > 1;
      final seriesId =
          useSeries
              ? (_seriesId ??
                  DateTime.now().microsecondsSinceEpoch.toString())
              : null;

      final baseId = DateTime.now().microsecondsSinceEpoch.toString();
      final toSave = <ClassEntry>[];
      for (final weekday in selectedWeekdays) {
        ClassEntry? existing;
        for (final entry in _loadedEntries) {
          if (entry.weekday == weekday) {
            existing = entry;
            break;
          }
        }
        toSave.add(
          ClassEntry(
            id: existing?.id ?? '$baseId-$weekday',
            weekday: weekday,
            subject: trimmedSubject,
            startTime: trimmedStart,
            endTime: trimmedEnd,
            seriesId: seriesId,
            room: roomValue,
            notes: notesValue,
          ),
        );
      }

      final deleteIds =
          _loadedEntries
              .where((e) => !selectedWeekdays.contains(e.weekday))
              .map((e) => e.id)
              .toList();

      await _repository.saveAll(toSave, deleteIds: deleteIds);
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
