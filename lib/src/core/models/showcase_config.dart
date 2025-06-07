import 'package:flutter/material.dart';
import 'package:walkthrux/src/core/enums/enums.dart';

class ShowcaseConfig {
  final String id;
  final String title;
  final String description;
  final Widget? child;
  final GlobalKey targetKey;
  final TooltipPosition tooltipPosition;
  final ShowcaseShape shape;
  final Color overlayColor;
  final double overlayOpacity;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final bool enablePulseAnimation;
  final Color pulseColor;
  final Widget? customTooltip;
  final String? audioPath;
  final bool enableTTS;
  final VoidCallback? onShow;
  final VoidCallback? onDismiss;
  final Map<String, dynamic>? analyticsData;

  const ShowcaseConfig({
    required this.id,
    required this.title,
    required this.description,
    required this.targetKey,
    this.child,
    this.tooltipPosition = TooltipPosition.auto,
    this.shape = ShowcaseShape.rectangle,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.75,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius,
    this.enablePulseAnimation = true,
    this.pulseColor = Colors.white,
    this.customTooltip,
    this.audioPath,
    this.enableTTS = false,
    this.onShow,
    this.onDismiss,
    this.analyticsData,
  });
}
