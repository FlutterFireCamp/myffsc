import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/podium_user_entity.dart';

class TopThreePodium extends StatelessWidget {
  final List<PodiumUserEntity> topThree;

  const TopThreePodium({super.key, required this.topThree});

  @override
  Widget build(BuildContext context) {
    if (topThree.isEmpty) return const SizedBox.shrink();

    final first = topThree.isNotEmpty ? topThree[0] : null;
    final second = topThree.length > 1 ? topThree[1] : null;
    final third = topThree.length > 2 ? topThree[2] : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular20,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place (Left)
          if (second != null)
            _buildPodiumColumn(
              user: second,
              rankText: "2e",
              badgeColor: const Color(0xFF94A3B8), // Silver
              badgeTextColor: Colors.white,
              pedestalHeight: 8.5.h,
              isFirst: false,
            )
          else
            const Expanded(child: SizedBox.shrink()),

          SizedBox(width: 1.5.w),

          // 1st Place (Center - Elevated)
          if (first != null)
            _buildPodiumColumn(
              user: first,
              rankText: "1er",
              badgeColor: const Color(0xFFFBBF24), // Gold
              badgeTextColor: Colors.black,
              pedestalHeight: 10.5.h,
              isFirst: true,
            )
          else
            const Expanded(child: SizedBox.shrink()),

          SizedBox(width: 1.5.w),

          // 3rd Place (Right)
          if (third != null)
            _buildPodiumColumn(
              user: third,
              rankText: "3e",
              badgeColor: const Color(0xFFD97706), // Bronze
              badgeTextColor: Colors.white,
              pedestalHeight: 7.5.h,
              isFirst: false,
            )
          else
            const Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn({
    required PodiumUserEntity user,
    required String rankText,
    required Color badgeColor,
    required Color badgeTextColor,
    required double pedestalHeight,
    required bool isFirst,
  }) {
    final avatarRadius = isFirst ? 26.0 : 20.0;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Avatar + Rank Badge Overlay
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: badgeColor,
                    width: isFirst ? 2.5 : 1.8,
                  ),
                ),
                child: AppCachedAvatar(
                  imageUrl: user.photoUrl,
                  radius: avatarRadius,
                  fallbackInitial: user.name.isNotEmpty ? user.name[0] : 'A',
                  fallbackTextStyle: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.2.w,
                    vertical: 0.2.h,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: AppRadius.circular12,
                  ),
                  child: Text(
                    rankText,
                    style: AppTextStyles.caption.copyWith(
                      color: badgeTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: isFirst ? 14.sp : 13.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),

          // User Name
          Text(
            user.name.split(' ').first,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.2.h),

          // Country Flag
          if (user.flag.isNotEmpty)
            Text(
              user.flag,
              style: TextStyle(fontSize: isFirst ? 16.sp : 14.sp),
            ),
          SizedBox(height: 1.h),

          // Pedestal Box
          Container(
            width: double.infinity,
            height: pedestalHeight,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: isFirst
                  ? badgeColor.withValues(alpha: 0.12)
                  : AppColors.cardHover.withValues(alpha: 0.8),
              borderRadius: AppRadius.circular14,
              border: Border.all(
                color: isFirst
                    ? badgeColor.withValues(alpha: 0.7)
                    : AppColors.borderSubtle,
                width: isFirst ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${user.totalPoints} pts",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isFirst ? badgeColor : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: isFirst ? 16.sp : 14.sp,
                  ),
                ),
                SizedBox(height: 0.2.h),
                Text(
                  "Niv. ${user.level}",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
