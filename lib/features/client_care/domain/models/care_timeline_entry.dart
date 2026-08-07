enum CareTimelineSource { encounter, appointment }

class CareTimelineEntry {
  const CareTimelineEntry({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.source,
    this.contextLabel,
    this.serviceType,
  });

  final String id;
  final String body;
  final DateTime createdAt;
  final CareTimelineSource source;
  final String? contextLabel;
  final String? serviceType;
}
