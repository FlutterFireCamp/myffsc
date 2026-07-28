import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_colors.dart';

/// Centralized Typography System for the app.
/// Specifying `fontFamily: 'Outfit'` once ensures consistency across all widgets.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Outfit';

  // --- Headings & Hero Titles ---
  static TextStyle get heroTitle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 25.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get heroSubtitle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      );

  static TextStyle get h1 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 23.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get h2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.5.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get h3 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18.5.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17.5.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.5.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // --- Body Styles (High Visibility & Readability) ---
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15.5.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.5.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // --- Specialized Styles ---
  static TextStyle get button => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get buttonSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get badge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13.5.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.skyBlue,
      );

  static TextStyle get badgeSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.skyBlue,
      );

  static TextStyle get caption => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.textMuted,
      );

  static TextStyle get navLabel => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get navLabelActive => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
      );
}
