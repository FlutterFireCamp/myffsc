import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class CurrentUserRankCard extends StatelessWidget {
  final int userRank;
  final int totalParticipants;
  final int totalPoints;
  final int level;

  const CurrentUserRankCard({
    super.key,
    required this.userRank,
    required this.totalParticipants,
    required this.totalPoints,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular14,
        border: Border.all(
          color: AppColors.skyBlue.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // Circle Rank Badge Left
          Container(
            width: 9.w,
            height: 9.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.skyBlue.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.skyBlue,
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                "${userRank}e",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.skyBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 9.5.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),

          // Title & Details Center
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Votre Position Actuelle",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 0.2.h),
                Text(
                  "${userRank}e sur $totalParticipants participants",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 9.5.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),

          // Points & Level Right
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$totalPoints pts",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.skyBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.5.sp,
                ),
              ),
              SizedBox(height: 0.2.h),
              Text(
                "Niv. $level",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 9.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
