import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// Reusable application text field with built-in tap-outside handling to unfocus
/// and dismiss keyboard automatically across the entire app.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final int maxLines;
  final int? minLines;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLength;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onTap;
  final bool enableInteractiveSelection;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;

  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLength,
    this.style,
    this.hintStyle,
    this.onTapOutside,
    this.onTap,
    this.enableInteractiveSelection = true,
    this.contentPadding,
    this.fillColor,
    this.decoration,
    this.inputFormatters,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = (decoration ?? const InputDecoration()).copyWith(
      hintText: hintText ?? decoration?.hintText,
      hintStyle: hintStyle ??
          decoration?.hintStyle ??
          AppTextStyles.bodySmall.copyWith(
            color: AppColors.textMuted,
          ),
      prefixIcon: prefixIcon ?? decoration?.prefixIcon,
      suffixIcon: suffixIcon ?? decoration?.suffixIcon,
      filled: decoration?.filled ?? true,
      fillColor: fillColor ?? decoration?.fillColor ?? AppColors.card,
      contentPadding: contentPadding ??
          decoration?.contentPadding ??
          EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: maxLines > 1 ? 1.6.h : 1.4.h,
          ),
      border: decoration?.border ??
          const OutlineInputBorder(
            borderRadius: AppRadius.circular12,
            borderSide: BorderSide(color: AppColors.borderSubtle),
          ),
      enabledBorder: decoration?.enabledBorder ??
          const OutlineInputBorder(
            borderRadius: AppRadius.circular12,
            borderSide: BorderSide(color: AppColors.borderSubtle),
          ),
      focusedBorder: decoration?.focusedBorder ??
          const OutlineInputBorder(
            borderRadius: AppRadius.circular12,
            borderSide: BorderSide(color: AppColors.skyBlue, width: 1.5),
          ),
      errorBorder: decoration?.errorBorder ??
          const OutlineInputBorder(
            borderRadius: AppRadius.circular12,
            borderSide: BorderSide(color: AppColors.errorText, width: 1.2),
          ),
      focusedErrorBorder: decoration?.focusedErrorBorder ??
          const OutlineInputBorder(
            borderRadius: AppRadius.circular12,
            borderSide: BorderSide(color: AppColors.errorText, width: 1.5),
          ),
    );

    final field = TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onTap: onTap,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      enableInteractiveSelection: enableInteractiveSelection,
      // Automatic tap-outside handling to unfocus and close keyboard
      onTapOutside: onTapOutside ??
          (PointerDownEvent event) {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
      style: style ??
          AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
      decoration: effectiveDecoration,
    );

    if (label != null && label!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 0.8.h),
          field,
        ],
      );
    }

    return field;
  }
}
