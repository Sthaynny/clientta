import 'package:flutter_test/flutter_test.dart';
import 'package:university_hub/core/schedule/academic_night_shift.dart';

void main() {
  test('períodos noturnos N1–N4 seguem grade de referência', () {
    expect(academicNightPeriods.length, 4);
    expect(academicNightPeriods.first.startTime, '18:50');
    expect(academicNightPeriods.first.endTime, '19:40');
    expect(academicNightPeriods.last.startTime, '21:30');
    expect(academicNightPeriods.last.endTime, '22:20');
  });

  test('bloco N1234 cobre aula noturna completa', () {
    final block = academicNightBlocks.first;
    expect(block.label, 'N1234');
    expect(block.startTime, '18:50');
    expect(block.endTime, '22:20');

    final range = nightRangeForPeriods(1, 4);
    expect(range?.startTime, '18:50');
    expect(range?.endTime, '22:20');
  });

  test('bloco N123 termina no fim do terceiro período', () {
    final block = academicNightBlocks[1];
    expect(block.label, 'N123');
    expect(block.endTime, '21:30');
  });
}
