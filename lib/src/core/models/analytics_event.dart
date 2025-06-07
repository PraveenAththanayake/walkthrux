class AnalyticsEvent {
  final String eventName;
  final String showcaseId;
  final DateTime timestamp;
  final Map<String, dynamic> properties;
  final Duration? duration;

  AnalyticsEvent({
    required this.eventName,
    required this.showcaseId,
    required this.timestamp,
    this.properties = const {},
    this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'showcaseId': showcaseId,
      'timestamp': timestamp.toIso8601String(),
      'properties': properties,
      'duration': duration?.inMilliseconds,
    };
  }

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvent(
      eventName: json['eventName'],
      showcaseId: json['showcaseId'],
      timestamp: DateTime.parse(json['timestamp']),
      properties: json['properties'] ?? {},
      duration:
          json['duration'] != null
              ? Duration(milliseconds: json['duration'])
              : null,
    );
  }
}
