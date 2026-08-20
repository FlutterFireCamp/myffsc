import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class PodiumShimmer extends StatelessWidget {
  const PodiumShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
          // 1. Top 3 Podium Skeletons
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular20,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: .spaceEvenly,
              crossAxisAlignment: .end,
              children: [
                // Rank 2 (Silver)
                _buildPodiumStepSkeleton(
                  avatarRadius: 22,
                  pillarHeight: 14.h,
                  pillarColor: const Color(0xFF24344C),
                ),
                // Rank 1 (Gold)
                _buildPodiumStepSkeleton(
                  avatarRadius: 28,
                  pillarHeight: 19.h,
                  pillarColor: const Color(0xFF2E3E59),
                  hasCrown: true,
                ),
                // Rank 3 (Bronze)
                _buildPodiumStepSkeleton(
                  avatarRadius: 22,
                  pillarHeight: 11.h,
                  pillarColor: const Color(0xFF1E293B),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Section Title
          AppShimmerBox(
            width: 45.w,
            height: 2.2.h,
            color: const Color(0xFF26354D),
          ),
          SizedBox(height: 1.5.h),

          // 2. Leaderboard List Rows (Ranks 4+)
          ...List.generate(
            4,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 1.2.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular14,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    // Rank number badge
                    AppShimmerBox(
                      width: 7.w,
                      height: 2.h,
                      borderRadius: AppRadius.circular4,
                      color: const Color(0xFF26354D),
                    ),
                    SizedBox(width: 3.w),

                    // Avatar
                    const AppShimmerCircle(
                      radius: 18,
                      color: Color(0xFF26354D),
                    ),
                    SizedBox(width: 3.w),

                    // Name & Country
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 0.6.h,
                        children: [
                          AppShimmerBox(
                            width: 35.w,
                            height: 1.8.h,
                            color: const Color(0xFF2E3E59),
                          ),
                          AppShimmerBox(
                            width: 25.w,
                            height: 1.4.h,
                            color: const Color(0xFF1E293B),
                          ),
                        ],
                      ),
                    ),

                    // Points Chip
                    AppShimmerBox(
                      width: 18.w,
                      height: 2.8.h,
                      borderRadius: AppRadius.circular8,
                      color: const Color(0xFF26354D),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumStepSkeleton({
    required double avatarRadius,
    required double pillarHeight,
    required Color pillarColor,
    bool hasCrown = false,
  }) {
    return Column(
      mainAxisSize: .min,
      children: [
        if (hasCrown) ...[
          const AppShimmerCircle(radius: 10, color: Color(0xFF2E3E59)),
          SizedBox(height: 0.6.h),
        ],
        AppShimmerCircle(radius: avatarRadius, color: const Color(0xFF26354D)),
        SizedBox(height: 0.8.h),
        AppShimmerBox(
          width: 20.w,
          height: 1.4.h,
          borderRadius: AppRadius.circular4,
          color: const Color(0xFF2E3E59),
        ),
        SizedBox(height: 0.4.h),
        AppShimmerBox(
          width: 15.w,
          height: 1.2.h,
          borderRadius: AppRadius.circular4,
          color: const Color(0xFF1E293B),
        ),
        SizedBox(height: 1.h),
        AppShimmerBox(
          width: 25.w,
          height: pillarHeight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          color: pillarColor,
        ),
      ],
    );
  }
}
