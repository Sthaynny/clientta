class ClassEntry {
  ClassEntry({
    required this.id,
    required this.weekday,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.room,
    this.notes,
  });

  final String id;
  final int weekday;
  final String subject;
  final String startTime;
  final String endTime;
  final String? room;
  final String? notes;

  factory ClassEntry.fromMap(Map<String, dynamic> map) {
    return ClassEntry(
      id: map['id'] as String,
      weekday: map['weekday'] as int,
      subject: map['subject'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      room: map['room'] as String?,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'weekday': weekday,
    'subject': subject,
    'startTime': startTime,
    'endTime': endTime,
    'room': room,
    'notes': notes,
  };

  ClassEntry copyWith({
    String? id,
    int? weekday,
    String? subject,
    String? startTime,
    String? endTime,
    String? room,
    String? notes,
  }) {
    return ClassEntry(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      subject: subject ?? this.subject,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      notes: notes ?? this.notes,
    );
  }
}
