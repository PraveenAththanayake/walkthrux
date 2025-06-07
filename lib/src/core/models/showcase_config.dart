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
  final Color highlightColor;
  final HighlightBehavior highlightBehavior;
  final Widget? customTooltip;
  final VoidCallback? onShow;
  final VoidCallback? onDismiss;
  final Map<String, dynamic>? analyticsData;
  final bool allowInteraction;
  final Duration? autoProgressDelay;
  final List<String>? prerequisites;
  final ShowcaseAnimation animationType;
  final Widget? customHighlight;
  final bool dismissOnTapOutside;
  final bool enableKeyboardNavigation;

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
    this.highlightBehavior = HighlightBehavior.pulse,
    this.highlightColor = Colors.white,
    this.customTooltip,
    this.onShow,
    this.onDismiss,
    this.analyticsData,
    this.allowInteraction = false,
    this.autoProgressDelay,
    this.prerequisites,
    this.animationType = ShowcaseAnimation.fade,
    this.customHighlight,
    this.dismissOnTapOutside = false,
    this.enableKeyboardNavigation = true,
  });

  ShowcaseConfig copyWith({
    String? id,
    String? title,
    String? description,
    Widget? child,
    GlobalKey? targetKey,
    TooltipPosition? tooltipPosition,
    ShowcaseShape? shape,
    Color? overlayColor,
    double? overlayOpacity,
    Duration? animationDuration,
    Curve? animationCurve,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    HighlightBehavior? highlightBehavior,
    Color? highlightColor,
    Widget? customTooltip,
    VoidCallback? onShow,
    VoidCallback? onDismiss,
    Map<String, dynamic>? analyticsData,
    bool? allowInteraction,
    Duration? autoProgressDelay,
    List<String>? prerequisites,
    ShowcaseAnimation? animationType,
    Widget? customHighlight,
    bool? dismissOnTapOutside,
    bool? enableKeyboardNavigation,
  }) {
    return ShowcaseConfig(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      child: child ?? this.child,
      targetKey: targetKey ?? this.targetKey,
      tooltipPosition: tooltipPosition ?? this.tooltipPosition,
      shape: shape ?? this.shape,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      highlightBehavior: highlightBehavior ?? this.highlightBehavior,
      highlightColor: highlightColor ?? this.highlightColor,
      customTooltip: customTooltip ?? this.customTooltip,
      onShow: onShow ?? this.onShow,
      onDismiss: onDismiss ?? this.onDismiss,
      analyticsData: analyticsData ?? this.analyticsData,
      allowInteraction: allowInteraction ?? this.allowInteraction,
      autoProgressDelay: autoProgressDelay ?? this.autoProgressDelay,
      prerequisites: prerequisites ?? this.prerequisites,
      animationType: animationType ?? this.animationType,
      customHighlight: customHighlight ?? this.customHighlight,
      dismissOnTapOutside: dismissOnTapOutside ?? this.dismissOnTapOutside,
      enableKeyboardNavigation:
          enableKeyboardNavigation ?? this.enableKeyboardNavigation,
    );
  }
}
