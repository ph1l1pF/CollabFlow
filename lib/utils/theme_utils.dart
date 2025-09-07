import 'package:flutter/material.dart';

class ThemeUtils {
  // Private constructor to prevent instantiation
  ThemeUtils._();

  /// Returns the appropriate background decoration based on the current theme
  static BoxDecoration getBackgroundDecoration(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    if (isDarkMode) {
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF000000), // Pure black
            Color(0xFF1a1a1a), // Dark gray
            Color(0xFF2d2d2d), // Lighter dark gray
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      );
    } else {
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF0F8), // Very light pink
            Color(0xFFFFE5F1), // Light pink
            Color(0xFFFFB3D1), // Medium pink
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      );
    }
  }
}
