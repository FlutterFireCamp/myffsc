import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class ProgramsShimmer extends StatelessWidget {
  const ProgramsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
          // 1. Filter Chips Row Skeleton
          Row(
            spacing: 2.w,
            children: [
              AppShimmerBox(
                width: 20.w,
                height: 4.h,
                borderRadius: AppRadius.circular12,
                color: const Color(0xFF26354D),
              ),
              AppShimmerBox(
                width: 25.w,
                height: 4.h,
                borderRadius: AppRadius.circular12,
                color: const Color(0xFF1E293B),
              ),
              AppShimmerBox(
                width: 28.w,
                height: 4.h,
                borderRadius: AppRadius.circular12,
                color: const Color(0xFF1E293B),
              ),
            ],
          ),
          SizedBox(height: 2.5.h),

          // 2. Program Cards Skeletons
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 2.h),
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
                    // Top: Circle Icon + Badge + Date
                    Row(
                      spacing: 3.5.w,
                      children: [
                        const AppShimmerCircle(
                          radius: 20,
                          color: Color(0xFF26354D),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            spacing: 0.8.h,
                            children: [
                              AppShimmerBox(
                                width: 22.w,
                                height: 2.h,
                                borderRadius: AppRadius.circular6,
                                color: const Color(0xFF26354D),
                              ),
                              AppShimmerBox(
                                width: 55.w,
                                height: 2.2.h,
                                borderRadius: AppRadius.circular6,
                                color: const Color(0xFF2E3E59),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.5.h),

                    // Date Row
                    Row(
                      spacing: 2.w,
                      children: [
                        const AppShimmerCircle(
                          radius: 8,
                          color: Color(0xFF26354D),
                        ),
                        AppShimmerBox(
                          width: 45.w,
                          height: 1.6.h,
                          borderRadius: AppRadius.circular4,
                          color: const Color(0xFF1E293B),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // Action Buttons Row
                    Row(
                      spacing: 2.w,
                      children: [
                        Expanded(
                          child: AppShimmerBox(
                            height: 4.5.h,
                            borderRadius: AppRadius.circular10,
                            color: const Color(0xFF26354D),
                          ),
                        ),
                        Expanded(
                          child: AppShimmerBox(
                            height: 4.5.h,
                            borderRadius: AppRadius.circular10,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
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
}
