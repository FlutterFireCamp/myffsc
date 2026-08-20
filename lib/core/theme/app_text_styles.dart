import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_colors.dart';

/// Centralized Typography System for the app.
/// Centralizes all text styles with responsive sizing so individual widgets
/// don't hardcode font sizes, making global typography updates simple and unified.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Outfit';

  // --- Headings & Hero Titles ---
  static TextStyle get heroTitle => TextStyle(
    fontFamily: fontFamily,
    fontSize: 25.sp,
    fontWeight: .bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get heroSubtitle => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.sp,
    fontWeight: .normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get h1 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 23.sp,
    fontWeight: .bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get h2 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.5.sp,
    fontWeight: .bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get h3 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.5.sp,
    fontWeight: .bold,
    color: AppColors.textPrimary,
  );

  // --- Titles ---
  static TextStyle get titleLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 17.5.sp,
    fontWeight: .bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: .w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5.sp,
    fontWeight: .w600,
    color: AppColors.textPrimary,
  );

  // --- Body Styles ---
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.5.sp,
    fontWeight: .normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5.sp,
    fontWeight: .normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5.sp,
    fontWeight: .normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // --- Buttons & Action Elements ---
  static TextStyle get button => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: .w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get buttonSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5.sp,
    fontWeight: .bold,
    color: AppColors.textPrimary,
  );

  // --- Badges & Chips ---
  static TextStyle get badge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: .bold,
    color: AppColors.skyBlue,
  );

  static TextStyle get badgeSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.5.sp,
    fontWeight: .bold,
    color: AppColors.skyBlue,
  );

  static TextStyle get tabLabel => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: .w600,
    color: AppColors.textPrimary,
  );

  // --- Metrics & Statistics ---
  static TextStyle get metricValue => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5.sp,
    fontWeight: .bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get metricLabel => TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.5.sp,
    fontWeight: .normal,
    color: AppColors.textMuted,
  );

  // --- Captions & Minor Info ---
  static TextStyle get caption => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.5.sp,
    fontWeight: .normal,
    color: AppColors.textMuted,
  );

  static TextStyle get captionSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: .normal,
    color: AppColors.textMuted,
  );

  // --- Navigation Labels ---
  static TextStyle get navLabel =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: .normal);

  static TextStyle get navLabelActive =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, fontWeight: .bold);
}
