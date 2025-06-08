import 'package:walkthrux/src/core/models/analytics_event.dart';
import 'package:walkthrux/src/core/types/types.dart';

/// Analytics service for tracking user interactions and showcase events.
///
/// Implements singleton pattern to ensure consistent event tracking across
/// the application. Manages session lifecycle, event collection, and
/// provides callback mechanism for real-time event processing.
class AnalyticsService {
  /// Singleton instance
  static final AnalyticsService _instance = AnalyticsService._internal();

  /// Factory constructor returns singleton instance
  factory AnalyticsService() => _instance;

  /// Private constructor for singleton pattern
  AnalyticsService._internal();

  /// Current session identifier
  String? _sessionId;

  /// Session start timestamp
  DateTime? _startTime;

  /// Collection of all events tracked during current session
  final List<AnalyticsEvent> _events = [];

  /// Optional callback invoked when events are tracked
  AnalyticsCallback? _callback;

  /// Maps showcase IDs to their start times for duration tracking
  final Map<String, DateTime> _showcaseStartTimes = {};

  /// Initializes a new analytics session.
  ///
  /// Clears any existing session data and starts fresh tracking.
  ///
  /// [sessionId] Unique identifier for this analytics session
  /// [onEvent] Optional callback invoked when events are tracked
  void initialize({required String sessionId, AnalyticsCallback? onEvent}) {
    _sessionId = sessionId;
    _startTime = DateTime.now();
    _callback = onEvent;
    _events.clear();
    _showcaseStartTimes.clear();
  }

  /// Tracks a generic analytics event.
  ///
  /// All specific tracking methods delegate to this core method.
  /// Events are only tracked if a session is active.
  ///
  /// [eventName] Type/name of the event being tracked
  /// [showcaseId] ID of the showcase associated with this event
  /// [properties] Optional additional data associated with the event
  void trackEvent(
    String eventName,
    String showcaseId, [
    Map<String, dynamic>? properties,
  ]) {
    // Guard clause: only track events during active sessions
    if (_sessionId == null) return;

    final event = AnalyticsEvent(
      eventName: eventName,
      showcaseId: showcaseId,
      timestamp: DateTime.now(),
      properties: properties ?? {},
    );

    _events.add(event);
    _callback?.call(event);
  }

  /// Tracks when a showcase begins.
  ///
  /// Records start time for duration calculation when showcase completes.
  ///
  /// [showcaseId] Unique identifier of the showcase being started
  void trackShowcaseStart(String showcaseId) {
    _showcaseStartTimes[showcaseId] = DateTime.now();
    trackEvent('showcase_start', showcaseId);
  }

  /// Tracks when a showcase is completed.
  ///
  /// Calculates and includes total duration if start time was recorded.
  /// Automatically cleans up stored start time.
  ///
  /// [showcaseId] Unique identifier of the showcase being completed
  void trackShowcaseComplete(String showcaseId) {
    final startTime = _showcaseStartTimes[showcaseId];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      trackEvent('showcase_complete', showcaseId, {
        'duration_ms': duration.inMilliseconds,
      });
      // Clean up: remove start time since showcase is complete
      _showcaseStartTimes.remove(showcaseId);
    }
  }

  /// Tracks when a user skips a showcase.
  ///
  /// Records which step the user was on when they chose to skip.
  ///
  /// [showcaseId] Unique identifier of the showcase being skipped
  /// [stepIndex] Zero-based index of the step where skip occurred
  void trackShowcaseSkip(String showcaseId, int stepIndex) {
    trackEvent('showcase_skip', showcaseId, {'step_index': stepIndex});
  }

  /// Tracks user interactions within a showcase.
  ///
  /// Generic method for tracking various user interactions like taps,
  /// gestures, or other custom interactions during showcase playback.
  ///
  /// [showcaseId] Unique identifier of the showcase
  /// [interactionType] Type of interaction (e.g., 'tap', 'swipe', 'custom')
  /// [data] Optional additional interaction data
  void trackInteraction(
    String showcaseId,
    String interactionType, [
    Map<String, dynamic>? data,
  ]) {
    trackEvent('showcase_interaction', showcaseId, {
      'interaction_type': interactionType,
      ...?data,
    });
  }

  /// Returns immutable copy of all tracked events.
  ///
  /// Prevents external modification of internal event collection
  /// while allowing read access for analysis or export.
  List<AnalyticsEvent> getEvents() => List.unmodifiable(_events);

  /// Ends the current analytics session.
  ///
  /// Tracks final session metrics and cleans up all session state.
  /// Should be called when the user session concludes or app terminates.
  void endSession() {
    // Track session summary if session is active
    if (_sessionId != null && _startTime != null) {
      trackEvent('session_end', 'session', {
        'total_duration_ms':
            DateTime.now().difference(_startTime!).inMilliseconds,
        'total_events': _events.length,
      });
    }

    // Clean up all session state
    _sessionId = null;
    _startTime = null;
    _showcaseStartTimes.clear();
  }
}
