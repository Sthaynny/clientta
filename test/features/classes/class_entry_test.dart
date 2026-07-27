import 'package:flutter_test/flutter_test.dart';
import 'package:university_hub/features/classes/domain/models/class_entry.dart';

void main() {
  test('ClassEntry serializa e restaura do mapa', () {
    final entry = ClassEntry(
      id: 'a',
      weekday: 2,
      subject: 'Algoritmos',
      startTime: '08:00',
      endTime: '10:00',
      room: 'Lab 3',
    );

    final restored = ClassEntry.fromMap(entry.toMap());

    expect(restored.weekday, 2);
    expect(restored.subject, 'Algoritmos');
    expect(restored.room, 'Lab 3');
    expect(restored.seriesId, isNull);
  });

  test('ClassEntry aceita seriesId no mapa', () {
    final map = <String, dynamic>{
      'id': 'b',
      'weekday': 3,
      'subject': 'BD',
      'startTime': '14:00',
      'endTime': '16:00',
      'seriesId': 'series-1',
    };
    final entry = ClassEntry.fromMap(map);
    expect(entry.seriesId, 'series-1');
    expect(entry.toMap()['seriesId'], 'series-1');
  });

  test('ClassEntry legado sem seriesId no mapa', () {
    final map = <String, dynamic>{
      'id': 'c',
      'weekday': 1,
      'subject': 'Redes',
      'startTime': '08:00',
      'endTime': '10:00',
    };
    expect(ClassEntry.fromMap(map).seriesId, isNull);
  });
}
