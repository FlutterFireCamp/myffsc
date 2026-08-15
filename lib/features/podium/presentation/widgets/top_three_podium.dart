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
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
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
              pedestalHeight: 9.h,
              isFirst: false,
            )
          else
            const Expanded(child: SizedBox.shrink()),

          SizedBox(width: 2.w),

          // 1st Place (Center - Elevated)
          if (first != null)
            _buildPodiumColumn(
              user: first,
              rankText: "1er",
              badgeColor: const Color(0xFFF59E0B), // Gold
              pedestalHeight: 12.h,
              isFirst: true,
            )
          else
            const Expanded(child: SizedBox.shrink()),

          SizedBox(width: 2.w),

          // 3rd Place (Right)
          if (third != null)
            _buildPodiumColumn(
              user: third,
              rankText: "3e",
              badgeColor: const Color(0xFFD97706), // Bronze
              pedestalHeight: 8.h,
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
    required double pedestalHeight,
    required bool isFirst,
  }) {
    final avatarRadius = isFirst ? 28.0 : 22.0;

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
                  border: Border.all(color: badgeColor, width: isFirst ? 2.5 : 1.8),
                ),
                child: AppCachedAvatar(
                  imageUrl: user.photoUrl,
                  radius: avatarRadius,
                  fallbackInitial: user.name.isNotEmpty ? user.name[0] : 'A',
                  fallbackTextStyle: AppTextStyles.h3.copyWith(color: Colors.white),
                ),
              ),
              Positioned(
                bottom: -10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.2.h),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: AppRadius.circular12,
                    boxShadow: [
                      BoxShadow(
                        color: badgeColor.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    rankText,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // User Name
          Text(
            user.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: isFirst ? 13.sp : 11.5.sp,
            ),
          ),
          SizedBox(height: 0.3.h),

          // Country Flag
          if (user.flag.isNotEmpty)
            Text(
              user.flag,
              style: TextStyle(fontSize: isFirst ? 14.sp : 12.sp),
            ),
          SizedBox(height: 1.2.h),

          // Pedestal Card Box
          Container(
            width: double.infinity,
            height: pedestalHeight,
            padding: EdgeInsets.symmetric(vertical: 1.2.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isFirst
                    ? [
                        badgeColor.withValues(alpha: 0.25),
                        badgeColor.withValues(alpha: 0.08),
                      ]
                    : [
                        AppColors.cardHover,
                        AppColors.modalBackground,
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: AppRadius.circular14,
              border: Border.all(
                color: isFirst
                    ? badgeColor.withValues(alpha: 0.6)
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
                    fontSize: isFirst ? 13.sp : 11.5.sp,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  "Niv. ${user.level}",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 9.sp,
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
