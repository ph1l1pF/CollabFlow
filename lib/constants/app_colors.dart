import 'package:flutter/material.dart';

class AppColors {
  // Primary pink color used throughout the app
  static const Color primaryPink = Color(0xFFFF69B4);
  
  // Pink color with opacity for backgrounds
  static Color get primaryPinkWithOpacity => primaryPink.withValues(alpha: 0.2);
  
  // Private constructor to prevent instantiation
  AppColors._();
}
