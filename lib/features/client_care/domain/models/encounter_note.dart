class EncounterNote {
  EncounterNote({
    required this.id,
    required this.clientPhone,
    required this.clientName,
    required this.body,
    required this.createdAt,
    this.serviceType,
    this.appointmentId,
    this.updatedAt,
  });

  final String id;
  final String clientPhone;
  final String clientName;
  final String? serviceType;
  final String? appointmentId;
  final String body;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory EncounterNote.fromMap(Map<String, dynamic> map) {
    return EncounterNote(
      id: map['id'] as String,
      clientPhone: map['clientPhone'] as String,
      clientName: map['clientName'] as String,
      serviceType: map['serviceType'] as String?,
      appointmentId: map['appointmentId'] as String?,
      body: map['body'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: _parseDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'clientPhone': clientPhone,
    'clientName': clientName,
    if (serviceType != null) 'serviceType': serviceType,
    if (appointmentId != null) 'appointmentId': appointmentId,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
  };

  EncounterNote copyWith({
    String? id,
    String? clientPhone,
    String? clientName,
    String? serviceType,
    bool clearServiceType = false,
    String? appointmentId,
    bool clearAppointmentId = false,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearUpdatedAt = false,
  }) {
    return EncounterNote(
      id: id ?? this.id,
      clientPhone: clientPhone ?? this.clientPhone,
      clientName: clientName ?? this.clientName,
      serviceType: clearServiceType ? null : (serviceType ?? this.serviceType),
      appointmentId:
          clearAppointmentId ? null : (appointmentId ?? this.appointmentId),
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: clearUpdatedAt ? null : (updatedAt ?? this.updatedAt),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
