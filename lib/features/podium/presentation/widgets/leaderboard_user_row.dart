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
    final community = user.displayCommunity;

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.actionBlue.withValues(alpha: 0.15)
            : AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(
          color: isCurrentUser
              ? AppColors.skyBlue.withValues(alpha: 0.5)
              : AppColors.borderSubtle,
          width: isCurrentUser ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Rank Badge Box
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
            decoration: BoxDecoration(
              color: AppColors.ultraDark,
              borderRadius: AppRadius.circular8,
              border: Border.all(color: AppColors.borderSubtle),
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
          SizedBox(width: 3.5.w),

          // User Avatar
          AppCachedAvatar(
            imageUrl: user.photoUrl,
            radius: 20,
            fallbackInitial: user.name.isNotEmpty ? user.name[0] : 'A',
            fallbackTextStyle: AppTextStyles.titleMedium.copyWith(color: Colors.white),
          ),
          SizedBox(width: 3.5.w),

          // User Details (Name, Flag, Community)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    if (user.flag.isNotEmpty) ...[
                      SizedBox(width: 1.5.w),
                      Text(user.flag, style: TextStyle(fontSize: 11.sp)),
                    ],
                  ],
                ),
                if (community.isNotEmpty) ...[
                  SizedBox(height: 0.3.h),
                  Text(
                    "• $community",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.skyBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 9.5.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 2.w),

          // Points & Level Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${user.totalPoints} pts",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.skyBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 0.3.h),
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
