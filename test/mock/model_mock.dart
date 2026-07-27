import 'package:university_hub/features/activities/domain/models/activity_entry.dart';
import 'package:university_hub/features/classes/domain/models/class_entry.dart';

final tMapClassEntry = <String, dynamic>{
  'id': 'class-1',
  'weekday': 2,
  'subject': 'Cálculo I',
  'startTime': '08:00',
  'endTime': '10:00',
  'room': 'Bloco A - 201',
  'notes': null,
};

final tInstanceClassEntry = ClassEntry.fromMap(tMapClassEntry);

final tMapActivityEntry = <String, dynamic>{
  'id': 'act-1',
  'title': 'Lista de exercícios',
  'date': '2026-03-10',
  'kind': 'trabalho',
  'done': false,
  'notes': 'Entregar no AVA',
};

final tInstanceActivityEntry = ActivityEntry.fromMap(tMapActivityEntry);
