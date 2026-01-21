import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized text styles for the Zen app
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // Noto Serif styles (for titles and important text)
  static TextStyle notoSerifBold(double size, {Color? color}) {
    return GoogleFonts.notoSerif(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.zenInk,
    );
  }

  static TextStyle notoSerifRegular(double size, {Color? color}) {
    return GoogleFonts.notoSerif(
      fontSize: size,
      color: color ?? AppColors.zenInk,
    );
  }

  // Noto Sans styles (for body text and UI elements)
  static TextStyle notoSansBold(
    double size, {
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.notoSans(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.zenInk,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle notoSansRegular(double size, {Color? color}) {
    return GoogleFonts.notoSans(
      fontSize: size,
      color: color ?? AppColors.zenInk,
    );
  }

  // Roboto Mono (for version numbers, codes)
  static TextStyle robotoMono(double size, {Color? color}) {
    return GoogleFonts.robotoMono(
      fontSize: size,
      color: color ?? AppColors.zenSubtle,
    );
  }

  // Ma Shan Zheng (for decorative Chinese text)
  static TextStyle maShanZheng(double size, {Color? color}) {
    return GoogleFonts.maShanZheng(
      fontSize: size,
      color: color ?? AppColors.zenInk,
    );
  }

  // Common presets
  static TextStyle get appBarTitle => notoSansBold(16, color: AppColors.zenInk);
  static TextStyle get sectionTitle => notoSerifBold(20);
  static TextStyle get bodyText => notoSansRegular(14);
  static TextStyle get caption =>
      TextStyle(fontSize: 12, color: AppColors.zenSubtle);
}
