import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      children: [
        // 1. Header Level Progress Banner Skeleton
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: AppRadius.circular20,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: AppShimmer(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    AppShimmerBox(
                      width: 45.w,
                      height: 3.h,
                      borderRadius: AppRadius.circular10,
                    ),
                    const AppShimmerCircle(radius: 16),
                  ],
                ),
                SizedBox(height: 2.h),
                AppShimmerBox(
                  width: 55.w,
                  height: 2.6.h,
                  borderRadius: AppRadius.circular6,
                ),
                SizedBox(height: 0.8.h),
                AppShimmerBox(
                  width: 85.w,
                  height: 1.5.h,
                  borderRadius: AppRadius.circular4,
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    AppShimmerBox(
                      width: 35.w,
                      height: 1.8.h,
                      borderRadius: AppRadius.circular4,
                    ),
                    AppShimmerBox(
                      width: 12.w,
                      height: 1.8.h,
                      borderRadius: AppRadius.circular4,
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                AppShimmerBox(
                  width: double.infinity,
                  height: 8,
                  borderRadius: AppRadius.circular10,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.5.h),

        // 2. Section Title
        AppShimmer(
          child: AppShimmerBox(
            width: 45.w,
            height: 2.2.h,
            borderRadius: AppRadius.circular6,
          ),
        ),
        SizedBox(height: 1.2.h),

        // 3. Today Program Card Skeleton
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: AppRadius.circular16,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: AppShimmer(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  spacing: 3.5.w,
                  children: [
                    const AppShimmerCircle(radius: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 0.6.h,
                        children: [
                          AppShimmerBox(
                            width: 22.w,
                            height: 1.8.h,
                            borderRadius: AppRadius.circular6,
                          ),
                          AppShimmerBox(
                            width: 60.w,
                            height: 2.2.h,
                            borderRadius: AppRadius.circular6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Row(
                  spacing: 2.w,
                  children: [
                    const AppShimmerCircle(radius: 7),
                    AppShimmerBox(
                      width: 45.w,
                      height: 1.5.h,
                      borderRadius: AppRadius.circular4,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  spacing: 2.w,
                  children: [
                    Expanded(
                      child: AppShimmerBox(
                        height: 4.5.h,
                        borderRadius: AppRadius.circular10,
                      ),
                    ),
                    Expanded(
                      child: AppShimmerBox(
                        height: 4.5.h,
                        borderRadius: AppRadius.circular10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.5.h),

        // 4. Section Title
        AppShimmer(
          child: AppShimmerBox(
            width: 45.w,
            height: 2.2.h,
            borderRadius: AppRadius.circular6,
          ),
        ),
        SizedBox(height: 1.2.h),

        // 5. Quick Action Cards Row Skeleton (2 cards)
        Row(
          spacing: 3.w,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: AppShimmer(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      const AppShimmerCircle(radius: 18),
                      SizedBox(height: 1.5.h),
                      AppShimmerBox(
                        width: 25.w,
                        height: 2.h,
                        borderRadius: AppRadius.circular6,
                      ),
                      SizedBox(height: 0.6.h),
                      AppShimmerBox(
                        width: 20.w,
                        height: 1.4.h,
                        borderRadius: AppRadius.circular4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: AppShimmer(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      const AppShimmerCircle(radius: 18),
                      SizedBox(height: 1.5.h),
                      AppShimmerBox(
                        width: 25.w,
                        height: 2.h,
                        borderRadius: AppRadius.circular6,
                      ),
                      SizedBox(height: 0.6.h),
                      AppShimmerBox(
                        width: 20.w,
                        height: 1.4.h,
                        borderRadius: AppRadius.circular4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
