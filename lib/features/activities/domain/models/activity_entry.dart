enum ActivityKind { aula, estudo, trabalho, prova, outro }

extension ActivityKindLabel on ActivityKind {
  String get label => switch (this) {
    ActivityKind.aula => 'Aula / presença',
    ActivityKind.estudo => 'Estudo',
    ActivityKind.trabalho => 'Trabalho / entrega',
    ActivityKind.prova => 'Prova / avaliação',
    ActivityKind.outro => 'Outro',
  };

  static ActivityKind fromName(String name) {
    return ActivityKind.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ActivityKind.outro,
    );
  }
}

class ActivityEntry {
  ActivityEntry({
    required this.id,
    required this.title,
    required this.date,
    required this.kind,
    this.done = false,
    this.notes,
  });

  final String id;
  final String title;
  final DateTime date;
  final ActivityKind kind;
  final bool done;
  final String? notes;

  factory ActivityEntry.fromMap(Map<String, dynamic> map) {
    final dateRaw = map['date'] as String;
    final parts = dateRaw.split('-');
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    return ActivityEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      date: date,
      kind: ActivityKindLabel.fromName(map['kind'] as String),
      done: map['done'] as bool? ?? false,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'date':
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}',
    'kind': kind.name,
    'done': done,
    'notes': notes,
  };

  ActivityEntry copyWith({
    String? id,
    String? title,
    DateTime? date,
    ActivityKind? kind,
    bool? done,
    String? notes,
  }) {
    return ActivityEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      kind: kind ?? this.kind,
      done: done ?? this.done,
      notes: notes ?? this.notes,
    );
  }
}
