import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/podium_user_entity.dart';

class LeaderboardUserRow extends StatelessWidget {
  final PodiumUserEntity user;
  final bool isCurrentUser;

  const LeaderboardUserRow({
    super.key,
    required this.user,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.2.h),
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.actionBlue.withValues(alpha: 0.15)
            : AppColors.card,
        borderRadius: AppRadius.circular14,
        border: Border.all(
          color: isCurrentUser
              ? AppColors.actionBlue.withValues(alpha: 0.5)
              : AppColors.borderSubtle,
          width: isCurrentUser ? 1.4 : 1.0,
        ),
      ),
      child: Row(
        spacing: 3.w,
        children: [
          // Rank Badge Box (#4, #5, ...)
          Text(
            "#${user.rank}",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: .bold,
            ),
          ),

          // Small User Avatar
          AppCachedAvatar(
            imageUrl: user.photoUrl,
            radius: 15,
            fallbackInitial: user.name.isNotEmpty ? user.name[0] : 'F',
            fallbackTextStyle: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: .bold,
            ),
          ),

          // User Name (Enlarged) & Country Flag Below
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              spacing: 0.2.h,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: .bold,
                  ),
                ),
                if (user.flag.isNotEmpty) Text(user.flag),
              ],
            ),
          ),

          // Points & Level Right Column
          Column(
            crossAxisAlignment: .end,
            mainAxisSize: .min,
            spacing: 0.2.h,
            children: [
              Text(
                "${user.totalPoints} pts",
                style: AppTextStyles.metricValue.copyWith(
                  color: AppColors.skyBlue,
                ),
              ),
              Text(
                "Niv. ${user.level}",
                style: AppTextStyles.metricLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
