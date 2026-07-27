import 'package:flutter_test/flutter_test.dart';
import 'package:university_hub/core/strings/daily_strings.dart';
import 'package:university_hub/core/utils/result.dart';
import 'package:university_hub/features/classes/domain/class_form_validation.dart';
import 'package:university_hub/features/classes/domain/models/class_day_schedule.dart';

void main() {
  const defaults = (
    sameTimeForAllDays: true,
    perDayTimes: <int, ClassDaySchedule>{},
  );

  test('validateClassForm exige ao menos um dia', () {
    final result = validateClassForm(
      selectedWeekdays: {},
      subject: 'Cálculo',
      sameTimeForAllDays: defaults.sameTimeForAllDays,
      startTime: '08:00',
      endTime: '10:00',
      perDayTimes: defaults.perDayTimes,
    );

    expect(result.isError, isTrue);
    expect(
      result.error.toString(),
      contains(errorClassWeekdayRequiredString),
    );
  });

  test('validateClassForm exige disciplina', () {
    final result = validateClassForm(
      selectedWeekdays: {1},
      subject: '   ',
      sameTimeForAllDays: defaults.sameTimeForAllDays,
      startTime: '08:00',
      endTime: '10:00',
      perDayTimes: defaults.perDayTimes,
    );

    expect(result.isError, isTrue);
    expect(
      result.error.toString(),
      contains(errorClassSubjectRequiredString),
    );
  });

  test('validateClassForm valida formato HH:mm no início', () {
    final result = validateClassForm(
      selectedWeekdays: {1},
      subject: 'Cálculo',
      sameTimeForAllDays: defaults.sameTimeForAllDays,
      startTime: '8:00',
      endTime: '10:00',
      perDayTimes: defaults.perDayTimes,
    );

    expect(result.isError, isTrue);
    expect(
      result.error.toString(),
      contains(errorClassStartTimeInvalidString),
    );
  });

  test('validateClassForm exige fim depois do início', () {
    final result = validateClassForm(
      selectedWeekdays: {1},
      subject: 'Cálculo',
      sameTimeForAllDays: defaults.sameTimeForAllDays,
      startTime: '10:00',
      endTime: '09:00',
      perDayTimes: defaults.perDayTimes,
    );

    expect(result.isError, isTrue);
    expect(
      result.error.toString(),
      contains(errorClassEndBeforeStartString),
    );
  });

  test('validateClassForm aceita horários válidos compartilhados', () {
    final result = validateClassForm(
      selectedWeekdays: {1, 3},
      subject: 'Cálculo',
      sameTimeForAllDays: true,
      startTime: '08:00',
      endTime: '10:00',
      perDayTimes: {},
    );

    expect(result.isOk, isTrue);
  });

  test('validateClassForm valida horário por dia', () {
    final result = validateClassForm(
      selectedWeekdays: {1, 2},
      subject: 'Educação física',
      sameTimeForAllDays: false,
      startTime: '08:00',
      endTime: '10:00',
      perDayTimes: {
        1: const ClassDaySchedule(startTime: '07:00', endTime: '08:00'),
        2: const ClassDaySchedule(startTime: '19:00', endTime: '18:00'),
      },
    );

    expect(result.isError, isTrue);
    expect(
      result.error.toString(),
      contains(errorClassEndBeforeStartString),
    );
  });

  test('validateClassForm aceita horários distintos por dia', () {
    final result = validateClassForm(
      selectedWeekdays: {1, 2},
      subject: 'Educação física',
      sameTimeForAllDays: false,
      startTime: '08:00',
      endTime: '10:00',
      perDayTimes: {
        1: const ClassDaySchedule(startTime: '07:00', endTime: '08:00'),
        2: const ClassDaySchedule(startTime: '19:00', endTime: '21:00'),
      },
    );

    expect(result.isOk, isTrue);
  });
}
