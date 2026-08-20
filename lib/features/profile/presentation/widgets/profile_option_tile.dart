import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class ProfileOptionTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circular16,
      child: Container(
        padding: .all(4.w),
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.incorrectContainer : AppColors.card,
          borderRadius: AppRadius.circular16,
          border: .all(
            color: isDestructive
                ? AppColors.incorrectBorder
                : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          spacing: 3.5.w,
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.alertRed.withValues(alpha: 0.15)
                    : AppColors.skyBlue.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular10,
              ),
              child: icon,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 0.3.h,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isDestructive
                          ? AppColors.errorText
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDestructive
                          ? AppColors.alertRed.withValues(alpha: 0.8)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AppIcons.arrowRight(
              color: isDestructive ? AppColors.errorText : AppColors.textMuted,
              size: AppSizes.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}
