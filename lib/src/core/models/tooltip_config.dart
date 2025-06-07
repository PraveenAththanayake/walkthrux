import 'package:flutter/material.dart';

class TooltipConfig {
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final Widget? customBackground;
  final List<BoxShadow>? shadows;
  final Border? border;
  final double maxWidth;
  final double minWidth;
  final bool showArrow;
  final Color arrowColor;
  final double arrowSize;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final List<Widget>? actionButtons;
  final Duration animationDuration;
  final Curve animationCurve;
  final Gradient? backgroundGradient;
  final bool enableBlur;
  final double blurRadius;
  final Matrix4? transform;
  final AlignmentGeometry alignment;
  final bool showProgress;
  final Color progressColor;
  final Widget? customArrow;
  final double elevation;

  const TooltipConfig({
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(20.0),
    this.titleStyle,
    this.descriptionStyle,
    this.customBackground,
    this.shadows,
    this.border,
    this.maxWidth = 320.0,
    this.minWidth = 240.0,
    this.showArrow = true,
    this.arrowColor = Colors.white,
    this.arrowSize = 16.0,
    this.leadingIcon,
    this.trailingIcon,
    this.actionButtons,
    this.animationDuration = const Duration(milliseconds: 350),
    this.animationCurve = Curves.elasticOut,
    this.backgroundGradient,
    this.enableBlur = true,
    this.blurRadius = 10.0,
    this.transform,
    this.alignment = Alignment.center,
    this.showProgress = true,
    this.progressColor = Colors.blue,
    this.customArrow,
    this.elevation = 8.0,
  });

  TooltipConfig copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
    EdgeInsets? padding,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    Widget? customBackground,
    List<BoxShadow>? shadows,
    Border? border,
    double? maxWidth,
    double? minWidth,
    bool? showArrow,
    Color? arrowColor,
    double? arrowSize,
    Widget? leadingIcon,
    Widget? trailingIcon,
    List<Widget>? actionButtons,
    Duration? animationDuration,
    Curve? animationCurve,
    Gradient? backgroundGradient,
    bool? enableBlur,
    double? blurRadius,
    Matrix4? transform,
    AlignmentGeometry? alignment,
    bool? showProgress,
    Color? progressColor,
    Widget? customArrow,
    double? elevation,
  }) {
    return TooltipConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      customBackground: customBackground ?? this.customBackground,
      shadows: shadows ?? this.shadows,
      border: border ?? this.border,
      maxWidth: maxWidth ?? this.maxWidth,
      minWidth: minWidth ?? this.minWidth,
      showArrow: showArrow ?? this.showArrow,
      arrowColor: arrowColor ?? this.arrowColor,
      arrowSize: arrowSize ?? this.arrowSize,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingIcon: trailingIcon ?? this.trailingIcon,
      actionButtons: actionButtons ?? this.actionButtons,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      enableBlur: enableBlur ?? this.enableBlur,
      blurRadius: blurRadius ?? this.blurRadius,
      transform: transform ?? this.transform,
      alignment: alignment ?? this.alignment,
      showProgress: showProgress ?? this.showProgress,
      progressColor: progressColor ?? this.progressColor,
      customArrow: customArrow ?? this.customArrow,
      elevation: elevation ?? this.elevation,
    );
  }
}
