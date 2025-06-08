import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:walkthrux/src/core/models/tooltip_config.dart';

class ThemeDetector {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static TooltipConfig getAdaptiveToolTipConfig(
    BuildContext context, [
    TooltipConfig? baseConfig,
  ]) {
    final isDark = isDarkMode(context);
    final theme = Theme.of(context);

    final defaultConfig = TooltipConfig(
      backgroundColor: isDark ? const Color(0xFF2D3748) : Colors.white,
      textColor: isDark ? Colors.white : const Color(0xFF2D3748),
      arrowColor: isDark ? const Color(0xFF2D3748) : Colors.white,
      progressColor: theme.primaryColor,
      shadows: [
        BoxShadow(
          color: isDark ? Colors.black26 : Colors.black12,
          blurRadius: 16,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
      ],
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : const Color(0xFF2D3748),
        height: 1.3,
      ),
      descriptionStyle: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.white70 : const Color(0xFF4A5568),
        height: 1.5,
      ),
    );

    return baseConfig?.copyWith(
          backgroundColor: baseConfig.backgroundColor,
          textColor: baseConfig.textColor,
          arrowColor: baseConfig.arrowColor,
          progressColor: baseConfig.progressColor,
        ) ??
        defaultConfig;
  }
}
