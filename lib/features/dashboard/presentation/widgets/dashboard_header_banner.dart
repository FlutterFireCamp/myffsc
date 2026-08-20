import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class DashboardHeaderBanner extends StatelessWidget {
  final int userLevel;
  final int totalPoints;
  final VoidCallback onActionTap;

  const DashboardHeaderBanner({
    super.key,
    required this.userLevel,
    required this.totalPoints,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressPct = LevelConfig.calculateProgressPercentage(
      userLevel,
      totalPoints,
    );
    final levelConfig = LevelConfig.fromLevel(userLevel);
    final levelColor = levelConfig.levelColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular20,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // Level Title Badge & Level Emoji
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.5.w,
                  vertical: 0.7.h,
                ),
                decoration: BoxDecoration(
                  color: levelColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular10,
                  border: Border.all(color: levelColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  levelConfig.title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: levelColor,
                    fontWeight: .bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: levelColor.withValues(alpha: 0.15),
                  shape: .circle,
                  border: Border.all(color: levelColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  levelConfig.emoji,
                  style: AppTextStyles.titleMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          Text(
            "Ravis de te revoir !",
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 0.6.h),
          Text(
            levelConfig.subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),

          // Progress Bar Header
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Progression Globale",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: .w600,
                ),
              ),
              Text(
                "$progressPct%",
                style: AppTextStyles.titleMedium.copyWith(
                  color: levelColor,
                  fontWeight: .bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // Progress Bar
          ClipRRect(
            borderRadius: AppRadius.circular10,
            child: Container(
              height: 8,
              width: double.infinity,
              color: AppColors.ultraDark,
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: (progressPct / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: levelColor,
                        borderRadius: AppRadius.circular10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
