import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walkthrux/src/core/enums/enums.dart';
import 'package:walkthrux/src/core/models/analytics_event.dart';
import 'package:walkthrux/src/core/models/showcase_config.dart';
import 'package:walkthrux/src/services/analytics_service.dart';

class ProOnboarderController extends ChangeNotifier {
  final List<ShowcaseConfig> _showcases = [];
  int _currentIndex = 0;
  bool _isActive = false;
  AutoPlayMode _autoPlayMode = AutoPlayMode.none;
  Timer? _autoProgressTimer;
  bool _isPaused = false;
  final Map<String, bool> _completedPrerequisites = {};

  final AnalyticsService _analytics = AnalyticsService();

  // Public getters
  List<ShowcaseConfig> get showcases => List.unmodifiable(_showcases);
  int get currentIndex => _currentIndex;
  bool get isActive => _isActive;
  bool get isPaused => _isPaused;
  AutoPlayMode get autoPlayMode => _autoPlayMode;

  ShowcaseConfig? get currentShowcase =>
      _isActive && _currentIndex < _showcases.length
          ? _showcases[_currentIndex]
          : null;

  double get progress =>
      _showcases.isEmpty ? 0.0 : (_currentIndex + 1) / _showcases.length;

  bool get hasNext => _currentIndex < _showcases.length - 1;
  bool get hasPrevious => _currentIndex > 0;

  // Showcase management
  void addShowcase(ShowcaseConfig config) {
    _showcases.add(config);
    notifyListeners();
  }

  void addShowcases(List<ShowcaseConfig> configs) {
    _showcases.addAll(configs);
    notifyListeners();
  }

  void removeShowcase(String id) {
    _showcases.removeWhere((showcase) => showcase.id == id);
    notifyListeners();
  }

  void clearShowcases() {
    _showcases.clear();
    _currentIndex = 0;
    _completedPrerequisites.clear();
    notifyListeners();
  }

  bool _checkPrerequisites(ShowcaseConfig config) {
    if (config.prerequisites == null || config.prerequisites!.isEmpty) {
      return true;
    }

    for (final prerequisite in config.prerequisites!) {
      if (!(_completedPrerequisites[prerequisite] ?? false)) {
        return false;
      }
    }
    return true;
  }

  // Showcase flow control
  Future<void> start({
    String? sessionId,
    void Function(AnalyticsEvent)? onAnalyticsEvent,
    AutoPlayMode autoPlayMode = AutoPlayMode.none,
    int startIndex = 0,
  }) async {
    if (_showcases.isEmpty || _isActive) return;

    _isActive = true;
    _currentIndex = startIndex.clamp(0, _showcases.length - 1);
    _autoPlayMode = autoPlayMode;
    _isPaused = false;

    _analytics.initialize(
      sessionId: sessionId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      onEvent: onAnalyticsEvent,
    );

    _analytics.trackShowcaseStart(_showcases[_currentIndex].id);
    _startAutoProgressTimer();
    notifyListeners();
  }

  void _startAutoProgressTimer() {
    _autoProgressTimer?.cancel();

    if (_autoPlayMode != AutoPlayMode.none &&
        currentShowcase?.autoProgressDelay != null &&
        !_isPaused) {
      _autoProgressTimer = Timer(currentShowcase!.autoProgressDelay!, () {
        if (!_isPaused && _isActive) {
          next();
        }
      });
    }
  }

  Future<void> next() async {
    if (!_isActive || _currentIndex >= _showcases.length - 1) {
      await complete();
      return;
    }

    final currentShowcase = _showcases[_currentIndex];
    currentShowcase.onDismiss?.call();
    _analytics.trackShowcaseComplete(currentShowcase.id);
    _completedPrerequisites[currentShowcase.id] = true;

    _currentIndex++;

    while (_currentIndex < _showcases.length &&
        !_checkPrerequisites(_showcases[_currentIndex])) {
      _currentIndex++;
    }

    if (_currentIndex < _showcases.length) {
      final nextShowcase = _showcases[_currentIndex];
      nextShowcase.onShow?.call();
      _analytics.trackShowcaseStart(nextShowcase.id);
      _startAutoProgressTimer();
    }

    notifyListeners();
  }

  Future<void> previous() async {
    if (!_isActive || _currentIndex <= 0) return;

    _autoProgressTimer?.cancel();
    final currentShowcase = _showcases[_currentIndex];
    currentShowcase.onDismiss?.call();

    _currentIndex--;

    while (_currentIndex >= 0 &&
        !_checkPrerequisites(_showcases[_currentIndex])) {
      _currentIndex--;
    }

    if (_currentIndex >= 0) {
      final prevShowcase = _showcases[_currentIndex];
      prevShowcase.onShow?.call();
      _analytics.trackShowcaseStart(prevShowcase.id);
      _startAutoProgressTimer();
    }

    notifyListeners();
  }

  void pause() {
    _isPaused = true;
    _autoProgressTimer?.cancel();
    _analytics.trackEvent('showcase_pause', currentShowcase?.id ?? 'unknown');
    notifyListeners();
  }

  void resume() {
    _isPaused = false;
    _startAutoProgressTimer();
    _analytics.trackEvent('showcase_resume', currentShowcase?.id ?? 'unknown');
    notifyListeners();
  }

  Future<void> skip() async {
    if (!_isActive) return;

    _analytics.trackShowcaseSkip(
      currentShowcase?.id ?? 'unknown',
      _currentIndex,
    );
    await complete();
  }

  Future<void> complete() async {
    if (!_isActive) return;

    _autoProgressTimer?.cancel();

    if (currentShowcase != null) {
      _analytics.trackShowcaseComplete(currentShowcase!.id);
    }

    _isActive = false;
    _currentIndex = 0;
    _isPaused = false;

    _analytics.endSession();
    notifyListeners();
  }

  @override
  void dispose() {
    _autoProgressTimer?.cancel();
    super.dispose();
  }
}
