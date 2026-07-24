import 'package:flutter_test/flutter_test.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';

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
  });
}
