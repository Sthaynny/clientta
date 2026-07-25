class ClassEntry {
  ClassEntry({
    required this.id,
    required this.weekday,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.seriesId,
    this.room,
    this.notes,
  });

  final String id;
  final int weekday;
  final String subject;
  final String startTime;
  final String endTime;
  final String? seriesId;
  final String? room;
  final String? notes;

  factory ClassEntry.fromMap(Map<String, dynamic> map) {
    return ClassEntry(
      id: map['id'] as String,
      weekday: map['weekday'] as int,
      subject: map['subject'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      seriesId: map['seriesId'] as String?,
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
    if (seriesId != null) 'seriesId': seriesId,
    'room': room,
    'notes': notes,
  };

  ClassEntry copyWith({
    String? id,
    int? weekday,
    String? subject,
    String? startTime,
    String? endTime,
    String? seriesId,
    bool clearSeriesId = false,
    String? room,
    String? notes,
  }) {
    return ClassEntry(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      subject: subject ?? this.subject,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      seriesId: clearSeriesId ? null : (seriesId ?? this.seriesId),
      room: room ?? this.room,
      notes: notes ?? this.notes,
    );
  }
}
