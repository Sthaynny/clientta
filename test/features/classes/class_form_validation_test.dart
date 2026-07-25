import 'package:flutter_test/flutter_test.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/classes/domain/class_form_validation.dart';

void main() {
  test('validateClassForm exige ao menos um dia', () {
    final result = validateClassForm(
      selectedWeekdays: {},
      subject: 'Cálculo',
      startTime: '08:00',
      endTime: '10:00',
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
      startTime: '08:00',
      endTime: '10:00',
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
      startTime: '8:00',
      endTime: '10:00',
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
      startTime: '10:00',
      endTime: '09:00',
    );

    expect(result.isError, isTrue);
    expect(
      result.error.toString(),
      contains(errorClassEndBeforeStartString),
    );
  });

  test('validateClassForm aceita horários válidos', () {
    final result = validateClassForm(
      selectedWeekdays: {1, 3},
      subject: 'Cálculo',
      startTime: '08:00',
      endTime: '10:00',
    );

    expect(result.isOk, isTrue);
  });
}
