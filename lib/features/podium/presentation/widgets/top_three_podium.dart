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
        mainAxisAlignment: .spaceEvenly,
        crossAxisAlignment: .end,
        spacing: 1.5.w,
        children: [
          // 2nd Place (Left)
          if (second != null)
            _buildPodiumColumn(
              user: second,
              rankText: "2e",
              badgeColor: AppColors.silver,
              badgeTextColor: Colors.white,
              pedestalHeight: 8.5.h,
              isFirst: false,
            )
          else
            const Expanded(child: SizedBox.shrink()),

          // 1st Place (Center - Elevated)
          if (first != null)
            _buildPodiumColumn(
              user: first,
              rankText: "1er",
              badgeColor: AppColors.gold,
              badgeTextColor: Colors.black,
              pedestalHeight: 10.5.h,
              isFirst: true,
            )
          else
            const Expanded(child: SizedBox.shrink()),

          // 3rd Place (Right)
          if (third != null)
            _buildPodiumColumn(
              user: third,
              rankText: "3e",
              badgeColor: AppColors.bronze,
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
        mainAxisAlignment: .end,
        children: [
          // Avatar + Rank Badge Overlay
          Stack(
            alignment: .topCenter,
            clipBehavior: .none,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: .circle,
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
                    style: AppTextStyles.badge.copyWith(
                      color: badgeTextColor,
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
            textAlign: .center,
            maxLines: 1,
            overflow: .ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: .bold,
            ),
          ),
          SizedBox(height: 0.2.h),

          // Country Flag
          if (user.flag.isNotEmpty) Text(user.flag),
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
              mainAxisAlignment: .center,
              spacing: 0.2.h,
              children: [
                Text(
                  "${user.totalPoints} pts",
                  textAlign: .center,
                  style: AppTextStyles.metricValue.copyWith(
                    color: isFirst ? badgeColor : AppColors.textPrimary,
                  ),
                ),
                Text(
                  "Niv. ${user.level}",
                  textAlign: .center,
                  style: AppTextStyles.metricLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
