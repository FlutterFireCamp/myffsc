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
        spacing: 3.w,
        children: [
          // Circle Rank Badge Left
          Container(
            width: 9.w,
            height: 9.w,
            decoration: BoxDecoration(
              shape: .circle,
              color: AppColors.skyBlue.withValues(alpha: 0.15),
              border: Border.all(color: AppColors.skyBlue, width: 1.2),
            ),
            child: Center(
              child: Text(
                "${userRank}e",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.skyBlue,
                  fontWeight: .bold,
                ),
              ),
            ),
          ),

          // Title & Details Center
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              spacing: 0.2.h,
              children: [
                Text(
                  "Votre Position Actuelle",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: .bold,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: "${userRank}e",
                        style: const TextStyle(fontWeight: .bold),
                      ),
                      const TextSpan(text: " sur "),
                      TextSpan(
                        text: totalParticipants.toString(),
                        style: const TextStyle(fontWeight: .bold),
                      ),
                      const TextSpan(text: " participants"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Points & Level Right
          Column(
            crossAxisAlignment: .end,
            mainAxisSize: .min,
            spacing: 0.2.h,
            children: [
              Text(
                "$totalPoints pts",
                style: AppTextStyles.metricValue.copyWith(
                  color: AppColors.skyBlue,
                ),
              ),
              Text("Niv. $level", style: AppTextStyles.metricLabel),
            ],
          ),
        ],
      ),
    );
  }
}
