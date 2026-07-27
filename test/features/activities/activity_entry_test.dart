import 'package:flutter_test/flutter_test.dart';
import 'package:university_hub/features/activities/domain/models/activity_entry.dart';

void main() {
  test('ActivityEntry serializa e restaura do mapa', () {
    final entry = ActivityEntry(
      id: '1',
      title: 'Lista de Cálculo',
      date: DateTime(2026, 3, 10),
      kind: ActivityKind.trabalho,
      done: true,
      notes: 'Entregar no AVA',
    );

    final restored = ActivityEntry.fromMap(entry.toMap());

    expect(restored.id, entry.id);
    expect(restored.title, entry.title);
    expect(restored.kind, entry.kind);
    expect(restored.done, true);
    expect(restored.notes, entry.notes);
  });
}
