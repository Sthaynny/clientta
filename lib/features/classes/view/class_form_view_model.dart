import 'package:university_hub/core/utils/commands.dart';
import 'package:university_hub/core/utils/result.dart';
import 'package:university_hub/features/classes/domain/class_form_validation.dart';
import 'package:university_hub/features/classes/domain/models/class_day_schedule.dart';
import 'package:university_hub/features/classes/domain/models/class_entry.dart';
import 'package:university_hub/features/classes/domain/repositories/class_repository.dart';

class ClassFormViewModel {
  ClassFormViewModel({
    required ClassRepository repository,
    ClassEntry? initial,
  }) : _repository = repository,
       _initial = initial {
    save = CommandBase(_save);
    selectedWeekdays = {DateTime.now().weekday};
    _syncPerDayTimesFromShared();
  }

  final ClassRepository _repository;
  final ClassEntry? _initial;

  late final CommandBase<void> save;

  late Set<int> selectedWeekdays;
  bool sameTimeForAllDays = true;
  String subject = '';
  String startTime = '08:00';
  String endTime = '10:00';
  Map<int, ClassDaySchedule> perDayTimes = {};
  String room = '';
  String notes = '';

  List<ClassEntry> _loadedEntries = [];
  String? _seriesId;

  ClassDaySchedule _defaultSlot() =>
      ClassDaySchedule(startTime: startTime, endTime: endTime);

  void _syncPerDayTimesFromShared() {
    final slot = _defaultSlot();
    final next = <int, ClassDaySchedule>{};
    for (final weekday in selectedWeekdays) {
      next[weekday] = perDayTimes[weekday] ?? slot;
    }
    perDayTimes = next;
  }

  Future<void> hydrate() async {
    final entry = _initial;
    if (entry == null) return;

    subject = entry.subject;
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

    if (_loadedEntries.length == 1) {
      final only = _loadedEntries.first;
      startTime = only.startTime;
      endTime = only.endTime;
      sameTimeForAllDays = true;
      perDayTimes = {
        only.weekday: ClassDaySchedule(
          startTime: only.startTime,
          endTime: only.endTime,
        ),
      };
      return;
    }

    final first = _loadedEntries.first;
    sameTimeForAllDays = _loadedEntries.every(
      (e) => e.startTime == first.startTime && e.endTime == first.endTime,
    );

    perDayTimes = {
      for (final e in _loadedEntries)
        e.weekday: ClassDaySchedule(
          startTime: e.startTime,
          endTime: e.endTime,
        ),
    };

    if (sameTimeForAllDays) {
      startTime = first.startTime;
      endTime = first.endTime;
    } else {
      startTime = '08:00';
      endTime = '10:00';
    }
  }

  void toggleWeekdays(Set<int> weekdays) {
    selectedWeekdays = weekdays;
    _syncPerDayTimesFromShared();
  }

  void setSameTimeForAllDays(bool value) {
    sameTimeForAllDays = value;
    if (value) {
      final firstWeekday = selectedWeekdays.isEmpty
          ? null
          : (selectedWeekdays.toList()..sort()).first;
      if (firstWeekday != null) {
        final slot = perDayTimes[firstWeekday];
        if (slot != null) {
          startTime = slot.startTime;
          endTime = slot.endTime;
        }
      }
      _syncPerDayTimesFromShared();
    } else {
      _syncPerDayTimesFromShared();
    }
  }

  void updateSharedStartTime(String value) {
    startTime = value;
    if (sameTimeForAllDays) _syncPerDayTimesFromShared();
  }

  void updateSharedEndTime(String value) {
    endTime = value;
    if (sameTimeForAllDays) _syncPerDayTimesFromShared();
  }

  void updateDayStartTime(int weekday, String value) {
    final current = perDayTimes[weekday] ?? _defaultSlot();
    perDayTimes = {
      ...perDayTimes,
      weekday: current.copyWith(startTime: value),
    };
  }

  void updateDayEndTime(int weekday, String value) {
    final current = perDayTimes[weekday] ?? _defaultSlot();
    perDayTimes = {
      ...perDayTimes,
      weekday: current.copyWith(endTime: value),
    };
  }

  ClassDaySchedule? scheduleForWeekday(int weekday) => perDayTimes[weekday];

  void applyTimeRange(String start, String end, {int? weekday}) {
    if (weekday != null) {
      updateDayStartTime(weekday, start);
      updateDayEndTime(weekday, end);
      return;
    }
    updateSharedStartTime(start);
    updateSharedEndTime(end);
  }

  Future<Result<void>> _save() async {
    final validation = validateClassForm(
      selectedWeekdays: selectedWeekdays,
      subject: subject,
      sameTimeForAllDays: sameTimeForAllDays,
      startTime: startTime,
      endTime: endTime,
      perDayTimes: perDayTimes,
    );
    if (validation.isError) return validation;

    try {
      final trimmedSubject = subject.trim();
      final trimmedRoom = room.trim();
      final trimmedNotes = notes.trim();
      final roomValue = trimmedRoom.isEmpty ? null : trimmedRoom;
      final notesValue = trimmedNotes.isEmpty ? null : trimmedNotes;

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

        final ClassDaySchedule slot;
        if (sameTimeForAllDays) {
          slot = ClassDaySchedule(
            startTime: startTime.trim(),
            endTime: endTime.trim(),
          );
        } else {
          slot = perDayTimes[weekday]!;
        }

        toSave.add(
          ClassEntry(
            id: existing?.id ?? '$baseId-$weekday',
            weekday: weekday,
            subject: trimmedSubject,
            startTime: slot.startTime,
            endTime: slot.endTime,
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
