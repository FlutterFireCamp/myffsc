import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
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
                      color: const Color(0xFF26354D),
                    ),
                    const AppShimmerCircle(
                      radius: 16,
                      color: Color(0xFF26354D),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                AppShimmerBox(
                  width: 55.w,
                  height: 2.6.h,
                  color: const Color(0xFF2E3E59),
                ),
                SizedBox(height: 0.8.h),
                AppShimmerBox(
                  width: 85.w,
                  height: 1.6.h,
                  color: const Color(0xFF1E293B),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    AppShimmerBox(
                      width: 35.w,
                      height: 1.8.h,
                      color: const Color(0xFF222F44),
                    ),
                    AppShimmerBox(
                      width: 12.w,
                      height: 1.8.h,
                      color: const Color(0xFF26354D),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                AppShimmerBox(
                  width: double.infinity,
                  height: 8,
                  borderRadius: AppRadius.circular10,
                  color: const Color(0xFF1E293B),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.5.h),

          // 2. Section Header
          AppShimmerBox(
            width: 50.w,
            height: 2.4.h,
            color: const Color(0xFF26354D),
          ),
          SizedBox(height: 1.5.h),

          // 3. Quick Action Cards Row Skeleton
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
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      const AppShimmerCircle(
                        radius: 18,
                        color: Color(0xFF26354D),
                      ),
                      SizedBox(height: 1.5.h),
                      AppShimmerBox(
                        width: 25.w,
                        height: 2.h,
                        color: const Color(0xFF2E3E59),
                      ),
                      SizedBox(height: 0.6.h),
                      AppShimmerBox(
                        width: 20.w,
                        height: 1.4.h,
                        color: const Color(0xFF1E293B),
                      ),
                    ],
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
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      const AppShimmerCircle(
                        radius: 18,
                        color: Color(0xFF26354D),
                      ),
                      SizedBox(height: 1.5.h),
                      AppShimmerBox(
                        width: 25.w,
                        height: 2.h,
                        color: const Color(0xFF2E3E59),
                      ),
                      SizedBox(height: 0.6.h),
                      AppShimmerBox(
                        width: 20.w,
                        height: 1.4.h,
                        color: const Color(0xFF1E293B),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
