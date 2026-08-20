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
      padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 0),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle),
          left: BorderSide(color: AppColors.borderSubtle),
          right: BorderSide(color: AppColors.borderSubtle),
          bottom: BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        crossAxisAlignment: .end,
        spacing: 1.5.w,
        children: [
          // 2nd Place (Left - Silver)
          if (second != null)
            _buildPodiumColumn(
              user: second,
              rankText: "2e",
              badgeColor: const Color(0xFF94A3B8), // Silver
              badgeTextColor: Colors.white,
              pedestalHeight: 8.5.h,
              isFirst: false,
              gradientColors: [
                const Color(0xFF334155).withValues(alpha: 0.40),
                const Color(0xFF1E293B).withValues(alpha: 0.10),
              ],
              borderColor: const Color(0xFF64748B),
              pointsTextColor: Colors.white,
              levelTextColor: Colors.white.withValues(alpha: 0.65),
            )
          else
            const Expanded(child: SizedBox.shrink()),

          // 1st Place (Center - Gold Elevated)
          if (first != null)
            _buildPodiumColumn(
              user: first,
              rankText: "1er",
              badgeColor: const Color(0xFFFBBF24), // Gold
              badgeTextColor: Colors.black,
              pedestalHeight: 11.h,
              isFirst: true,
              gradientColors: [
                const Color(0xFFF59E0B).withValues(alpha: 0.28),
                const Color(0xFFB45309).withValues(alpha: 0.06),
              ],
              borderColor: const Color(0xFFFBBF24),
              pointsTextColor: const Color(0xFFFBBF24),
              levelTextColor: const Color(0xFFFBBF24).withValues(alpha: 0.80),
            )
          else
            const Expanded(child: SizedBox.shrink()),

          // 3rd Place (Right - Bronze)
          if (third != null)
            _buildPodiumColumn(
              user: third,
              rankText: "3e",
              badgeColor: const Color(0xFFD97706), // Bronze
              badgeTextColor: Colors.white,
              pedestalHeight: 7.5.h,
              isFirst: false,
              gradientColors: [
                const Color(0xFFEA580C).withValues(alpha: 0.28),
                const Color(0xFF7C2D12).withValues(alpha: 0.08),
              ],
              borderColor: const Color(0xFFD97706),
              pointsTextColor: const Color(0xFFD97706),
              levelTextColor: const Color(0xFFD97706).withValues(alpha: 0.80),
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
    required List<Color> gradientColors,
    required Color borderColor,
    required Color pointsTextColor,
    required Color levelTextColor,
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
                      fontWeight: .bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),

          // User Name
          Padding(
            padding: .symmetric(horizontal: 1.w),
            child: Text(
              user.name.split(' ').first.toUpperCase(),
              textAlign: .center,
              maxLines: 1,
              overflow: .ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: .bold,
              ),
            ),
          ),
          SizedBox(height: 0.3.h),

          // Country Flag
          if (user.flag.isNotEmpty)
            Text(user.flag, style: const TextStyle(fontSize: 14)),
          SizedBox(height: 1.h),

          // Pedestal Box (Without bottom border, with top-down gradient)
          Container(
            width: double.infinity,
            height: pedestalHeight,
            padding: .symmetric(vertical: 0.8.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(
                top: BorderSide(color: borderColor, width: 1.5),
                left: BorderSide(color: borderColor, width: 1.5),
                right: BorderSide(color: borderColor, width: 1.5),
                bottom: BorderSide.none, // Pas de bordure en bas
              ),
            ),
            child: Column(
              mainAxisAlignment: .center,
              spacing: 0.3.h,
              children: [
                Text(
                  "${user.totalPoints} pts",
                  textAlign: .center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: pointsTextColor,
                    fontWeight: .bold,
                    fontSize: isFirst ? 15.sp : 14.sp,
                  ),
                ),
                Text(
                  "Niv. ${user.level}",
                  textAlign: .center,
                  style: AppTextStyles.captionSmall.copyWith(
                    color: levelTextColor,
                    fontWeight: .w600,
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
