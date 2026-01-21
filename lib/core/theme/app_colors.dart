import 'package:flutter/material.dart';

/// Centralized color palette for the Zen app
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const zenBg = Color(0xFFFDFCF8);
  static const zenBrown = Color(0xFF8B5A2B);
  static const zenPaper = Color(0xFFF2EFE9);
  static const zenInk = Color(0xFF2C2C2C);
  static const zenSubtle = Color(0xFF9E9E9E);

  // Secondary Colors
  static const zenLightBeige = Color(0xFFF9F7F3);
  static const zenSepia = Color(0xFFEFEDE7);
  static const zenDarkBrown = Color(0xFF5D4F43);
  static const zenAccent = Color(0xFFD8D0C5);

  // Functional Colors
  static const error = Color(0xFFBA1A1A);
  static const success = Color(0xFF4CAF50);

  // Helper methods for alpha variations
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
