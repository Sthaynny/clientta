import 'package:flutter_test/flutter_test.dart';
import 'package:university_hub/features/classes/domain/models/class_entry.dart';
import 'package:university_hub/features/classes/domain/models/class_schedule_group.dart';

void main() {
  test('ClassScheduleGroup agrupa por seriesId e combina dias', () {
    const series = 'series-1';
    final entries = [
      ClassEntry(
        id: 'b',
        seriesId: series,
        weekday: 3,
        subject: 'BD',
        startTime: '10:00',
        endTime: '12:00',
      ),
      ClassEntry(
        id: 'a',
        seriesId: series,
        weekday: 1,
        subject: 'BD',
        startTime: '10:00',
        endTime: '12:00',
      ),
      ClassEntry(
        id: 'legacy',
        weekday: 5,
        subject: 'Redes',
        startTime: '08:00',
        endTime: '10:00',
      ),
    ];

    final groups = ClassScheduleGroup.fromEntries(entries);

    expect(groups.length, 2);
    expect(groups.first.combinedWeekdayLabel, 'Seg, Qua');
    expect(groups.first.entryIds, ['a', 'b']);
    expect(groups.last.combinedWeekdayLabel, 'Sex');
    expect(groups.last.entryIds, ['legacy']);
  });

  test('ClassScheduleGroup detecta horários diferentes na série', () {
    const series = 's2';
    final group = ClassScheduleGroup(
      entries: [
        ClassEntry(
          id: 'a',
          seriesId: series,
          weekday: 1,
          subject: 'EF',
          startTime: '07:00',
          endTime: '08:00',
        ),
        ClassEntry(
          id: 'b',
          seriesId: series,
          weekday: 2,
          subject: 'EF',
          startTime: '19:00',
          endTime: '21:00',
        ),
      ],
    );

    expect(group.hasVaryingTimes, isTrue);
  });
}
