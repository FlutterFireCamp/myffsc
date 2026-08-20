import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/theme.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? icon;
  final Color? accentColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.accentColor,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = accentColor ?? AppColors.skyBlue;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.12),
                shape: .circle,
                border: Border.all(
                  color: activeColor.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: icon ?? AppIcons.info(color: activeColor, size: 40),
            ),
            SizedBox(height: 2.5.h),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(fontWeight: .bold),
              textAlign: .center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 2.5.h),
              TextButton.icon(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.2.h,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.circular12,
                  ),
                ),
                icon: AppIcons.refresh03(color: activeColor, size: 20),
                label: Text(
                  actionLabel!,
                  style: AppTextStyles.buttonSmall.copyWith(color: activeColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
