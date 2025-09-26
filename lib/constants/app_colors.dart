import 'package:flutter/material.dart';


class AppColors {
  // Primary pink color used throughout the app
  static const Color primaryPink = Color(0xFFFF69B4);
  
  // Pink color with opacity for backgrounds
  static Color get primaryPinkWithOpacity => primaryPink.withValues(alpha: 0.2);
  
  // Primary button style used throughout the app
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryPink,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
  );
  
  // Private constructor to prevent instantiation
  AppColors._();
}
