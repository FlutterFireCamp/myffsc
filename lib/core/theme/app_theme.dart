import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: .dark,
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.flutterBlue,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.skyBlue,
        onPrimary: AppColors.ultraDark,
        primaryContainer: AppColors.navyCard,
        onPrimaryContainer: AppColors.skyBlue,
        secondary: AppColors.skyBlue,
        onSecondary: AppColors.ultraDark,
        secondaryContainer: AppColors.navySurface,
        onSecondaryContainer: AppColors.skyBlue,
        surface: AppColors.card,
        onSurface: AppColors.textPrimary,
        surfaceContainer: AppColors.card,
        surfaceContainerHigh: AppColors.cardHover,
        surfaceContainerHighest: AppColors.cardHover,
        surfaceContainerLow: AppColors.background,
        surfaceContainerLowest: AppColors.ultraDark,
        error: AppColors.errorText,
        onError: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: AppTextStyles.h3,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.modalBackground,
        modalBackgroundColor: AppColors.modalBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        clipBehavior: .antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.r28),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.circular16,
          side: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1,
        headlineMedium: AppTextStyles.h2,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.skyBlue,
          foregroundColor: AppColors.ultraDark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.circular12,
          ),
          textStyle: AppTextStyles.button.copyWith(
            color: AppColors.ultraDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.borderSubtle, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.circular12,
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        floatingLabelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.skyBlue,
          fontWeight: .w600,
        ),
        hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.circular12,
          borderSide: BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.circular12,
          borderSide: BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.circular12,
          borderSide: BorderSide(color: AppColors.skyBlue, width: 1.5),
        ),
      ),
    );
  }
}
