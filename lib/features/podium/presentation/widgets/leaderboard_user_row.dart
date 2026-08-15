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
              ? AppColors.skyBlue.withValues(alpha: 0.5)
              : AppColors.borderSubtle,
          width: isCurrentUser ? 1.4 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Rank Badge Box (#4, #5, ...)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppColors.cardHover,
              borderRadius: AppRadius.circular8,
              border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.5)),
            ),
            child: Text(
              "#${user.rank}",
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
          ),
          SizedBox(width: 3.w),

          // Small User Avatar
          AppCachedAvatar(
            imageUrl: user.photoUrl,
            radius: 15,
            fallbackInitial: user.name.isNotEmpty ? user.name[0] : 'A',
            fallbackTextStyle: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 3.w),

          // User Name (Enlarged) & Country Flag Below
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                if (user.flag.isNotEmpty) ...[
                  SizedBox(height: 0.2.h),
                  Text(
                    user.flag,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 2.w),

          // Points & Level Right Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${user.totalPoints} pts",
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.skyBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5.sp,
                ),
              ),
              SizedBox(height: 0.2.h),
              Text(
                "Niv. ${user.level}",
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
