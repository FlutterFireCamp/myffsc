import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/theme.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.skyBlue.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: icon ?? AppIcons.info(color: AppColors.skyBlue, size: 40),
            ),
            SizedBox(height: 2.5.h),
            Text(
              title,
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 2.5.h),
              TextButton.icon(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.circular12,
                  ),
                ),
                icon: AppIcons.refresh03(color: AppColors.skyBlue, size: 20),
                label: Text(
                  actionLabel!,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.skyBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
