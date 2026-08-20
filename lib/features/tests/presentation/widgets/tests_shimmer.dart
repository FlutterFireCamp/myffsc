import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class TestsShimmer extends StatelessWidget {
  const TestsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular20,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                // Top Row: Status Badge (Left) + Points (Right)
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    AppShimmerBox(
                      width: 28.w,
                      height: 2.6.h,
                      borderRadius: AppRadius.circular8,
                      color: const Color(0xFF26354D),
                    ),
                    AppShimmerBox(
                      width: 16.w,
                      height: 2.h,
                      borderRadius: AppRadius.circular6,
                      color: const Color(0xFF26354D),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Title
                AppShimmerBox(
                  width: 70.w,
                  height: 2.8.h,
                  borderRadius: AppRadius.circular8,
                  color: const Color(0xFF2E3E59),
                ),
                SizedBox(height: 1.h),

                // Subtitle / Description lines
                AppShimmerBox(
                  width: double.infinity,
                  height: 1.6.h,
                  borderRadius: AppRadius.circular4,
                  color: const Color(0xFF1E293B),
                ),
                SizedBox(height: 0.6.h),
                AppShimmerBox(
                  width: 80.w,
                  height: 1.6.h,
                  borderRadius: AppRadius.circular4,
                  color: const Color(0xFF1E293B),
                ),
                SizedBox(height: 2.h),

                // Schedule time box
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161F30),
                    borderRadius: AppRadius.circular8,
                    border: Border.all(color: const Color(0xFF243046)),
                  ),
                  child: Row(
                    spacing: 2.5.w,
                    children: [
                      const AppShimmerCircle(
                        radius: 8,
                        color: Color(0xFF26354D),
                      ),
                      AppShimmerBox(
                        width: 50.w,
                        height: 1.6.h,
                        borderRadius: AppRadius.circular4,
                        color: const Color(0xFF26354D),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.5.h),

                // Action Button
                AppShimmerBox(
                  width: double.infinity,
                  height: 5.2.h,
                  borderRadius: AppRadius.circular12,
                  color: const Color(0xFF26354D),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
