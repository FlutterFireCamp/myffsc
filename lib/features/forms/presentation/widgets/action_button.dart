import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.iconColor,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String? label;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.actionBlue;
    final fg = iconColor ?? Colors.white;

    Widget button = Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: bg,
      elevation: 2,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: fg,
      ),
    );

    if (label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular8,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Text(
              label!,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          button,
        ],
      );
    }

    return button;
  }
}
