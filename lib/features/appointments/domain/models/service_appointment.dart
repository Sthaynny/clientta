class ServiceAppointment {
  ServiceAppointment({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.serviceType,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.notes,
    this.seriesId,
  });

  final String id;
  final String clientName;
  final String clientPhone;
  final String serviceType;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final String status;
  final String? notes;
  final String? seriesId;

  factory ServiceAppointment.fromMap(Map<String, dynamic> map) {
    return ServiceAppointment(
      id: map['id'] as String,
      clientName: map['clientName'] as String,
      clientPhone: map['clientPhone'] as String,
      serviceType: map['serviceType'] as String,
      appointmentDate: DateTime.parse(map['appointmentDate'] as String),
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      status: map['status'] as String,
      notes: map['notes'] as String?,
      seriesId: map['seriesId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'serviceType': serviceType,
    'appointmentDate': _dateKey(appointmentDate),
    'startTime': startTime,
    'endTime': endTime,
    'status': status,
    if (notes != null) 'notes': notes,
    if (seriesId != null) 'seriesId': seriesId,
  };

  ServiceAppointment copyWith({
    String? id,
    String? clientName,
    String? clientPhone,
    String? serviceType,
    DateTime? appointmentDate,
    String? startTime,
    String? endTime,
    String? status,
    String? notes,
    bool clearNotes = false,
    String? seriesId,
    bool clearSeriesId = false,
  }) {
    return ServiceAppointment(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      serviceType: serviceType ?? this.serviceType,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      notes: clearNotes ? null : (notes ?? this.notes),
      seriesId: clearSeriesId ? null : (seriesId ?? this.seriesId),
    );
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
