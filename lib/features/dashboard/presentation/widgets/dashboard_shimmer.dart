import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(5.w),
      children: [
        // 1. Header Banner Skeleton
        AppShimmer(
          child: Container(
            height: 18.h,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular20,
            ),
          ),
        ),
        SizedBox(height: 2.5.h),

        // 2. Quick Action Cards Row Skeleton
        Row(
          spacing: 3.w,
          children: [
            Expanded(
              child: AppShimmer(
                child: Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: AppRadius.circular16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: AppShimmer(
                child: Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: AppRadius.circular16,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // 3. Section Header Skeleton
        AppShimmer(
          child: Container(
            height: 2.5.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular8,
            ),
          ),
        ),
        SizedBox(height: 1.5.h),

        // 4. Program Card Skeleton
        AppShimmer(
          child: Container(
            height: 20.h,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular16,
            ),
          ),
        ),
      ],
    );
  }
}
