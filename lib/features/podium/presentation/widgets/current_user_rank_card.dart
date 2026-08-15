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
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.modalBackground,
        borderRadius: AppRadius.circular16,
        border: Border.all(
          color: AppColors.skyBlue.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Circle Rank Badge Left
          Container(
            width: 13.w,
            height: 13.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.skyBlue.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.skyBlue,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                "${userRank}e",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.skyBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.5.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),

          // Title & Details Center
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Votre Position Actuelle",
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  "${userRank}e sur $totalParticipants participants",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.skyBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0.4.h),
              Text(
                "Niv. $level",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
