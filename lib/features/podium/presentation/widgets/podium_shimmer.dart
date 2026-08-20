import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class PodiumShimmer extends StatelessWidget {
  const PodiumShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      children: [
        // 1. Top 3 Podium Pillars Skeleton
        AppShimmer(
          child: Row(
            mainAxisAlignment: .center,
            crossAxisAlignment: .end,
            spacing: 3.w,
            children: [
              // Rank 2 Pillar
              Container(
                width: 25.w,
                height: 18.h,
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                ),
              ),
              // Rank 1 Pillar
              Container(
                width: 28.w,
                height: 24.h,
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                ),
              ),
              // Rank 3 Pillar
              Container(
                width: 25.w,
                height: 15.h,
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),

        // 2. Leaderboard Rows Skeleton
        ...List.generate(
          4,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 1.2.h),
            child: AppShimmer(
              child: Container(
                height: 7.h,
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
