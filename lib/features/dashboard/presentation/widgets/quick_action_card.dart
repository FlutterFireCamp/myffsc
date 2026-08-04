import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circular16,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.circular16,
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: backgroundColor.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular12,
              ),
              child: icon,
            ),
            SizedBox(height: 1.5.h),
            Text(
              title,
              style: AppTextStyles.titleMedium,
            ),
            SizedBox(height: 0.4.h),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
