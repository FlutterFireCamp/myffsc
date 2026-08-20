import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class PodiumShimmer extends StatelessWidget {
  const PodiumShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Top 3 Podium Skeletons (Fixed)
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
          child: Container(
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
            child: AppShimmer(
              child: Row(
                mainAxisAlignment: .spaceEvenly,
                crossAxisAlignment: .end,
                children: [
                  // Rank 2 (Silver)
                  _buildPodiumStepSkeleton(
                    avatarRadius: 22,
                    pillarHeight: 13.h,
                  ),
                  // Rank 1 (Gold)
                  _buildPodiumStepSkeleton(
                    avatarRadius: 28,
                    pillarHeight: 18.h,
                    hasCrown: true,
                  ),
                  // Rank 3 (Bronze)
                  _buildPodiumStepSkeleton(
                    avatarRadius: 22,
                    pillarHeight: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),

        // Section Title (Fixed)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: AppShimmer(
            child: AppShimmerBox(
              width: 40.w,
              height: 2.2.h,
              borderRadius: AppRadius.circular6,
            ),
          ),
        ),
        SizedBox(height: 1.h),

        // 2. Leaderboard List Rows (Ranks 4+)
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 0.5.h, bottom: 4.h),
            itemCount: 4,
            separatorBuilder: (context, index) => SizedBox(height: 1.2.h),
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: AppRadius.circular14,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: AppShimmer(
                child: Row(
                  children: [
                    // Rank number badge
                    AppShimmerBox(
                      width: 6.w,
                      height: 2.h,
                      borderRadius: AppRadius.circular4,
                    ),
                    SizedBox(width: 3.w),

                    // Avatar
                    const AppShimmerCircle(radius: 18),
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
                            borderRadius: AppRadius.circular4,
                          ),
                          AppShimmerBox(
                            width: 25.w,
                            height: 1.3.h,
                            borderRadius: AppRadius.circular4,
                          ),
                        ],
                      ),
                    ),

                    // Points Chip
                    AppShimmerBox(
                      width: 18.w,
                      height: 2.8.h,
                      borderRadius: AppRadius.circular8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumStepSkeleton({
    required double avatarRadius,
    required double pillarHeight,
    bool hasCrown = false,
  }) {
    return Column(
      mainAxisSize: .min,
      children: [
        if (hasCrown) ...[
          const AppShimmerCircle(radius: 10),
          SizedBox(height: 0.6.h),
        ],
        AppShimmerCircle(radius: avatarRadius),
        SizedBox(height: 0.8.h),
        AppShimmerBox(
          width: 20.w,
          height: 1.4.h,
          borderRadius: AppRadius.circular4,
        ),
        SizedBox(height: 0.4.h),
        AppShimmerBox(
          width: 15.w,
          height: 1.2.h,
          borderRadius: AppRadius.circular4,
        ),
        SizedBox(height: 1.h),
        AppShimmerBox(
          width: 25.w,
          height: pillarHeight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
      ],
    );
  }
}
