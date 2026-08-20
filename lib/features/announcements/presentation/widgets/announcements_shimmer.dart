import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class AnnouncementsShimmer extends StatelessWidget {
  const AnnouncementsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      children: [
        // 1. Filter Chips Row Skeleton (Horizontally scrollable to avoid any RenderFlex overflow)
        AppShimmer(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              spacing: 2.w,
              children: [
                AppShimmerBox(
                  width: 22.w,
                  height: 3.8.h,
                  borderRadius: AppRadius.circular12,
                ),
                AppShimmerBox(
                  width: 28.w,
                  height: 3.8.h,
                  borderRadius: AppRadius.circular12,
                ),
                AppShimmerBox(
                  width: 25.w,
                  height: 3.8.h,
                  borderRadius: AppRadius.circular12,
                ),
                AppShimmerBox(
                  width: 22.w,
                  height: 3.8.h,
                  borderRadius: AppRadius.circular12,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.5.h),

        // 2. Announcement Cards Skeletons
        ...List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Container(
              padding: EdgeInsets.all(4.5.w),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: AppRadius.circular16,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: AppShimmer(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    // Top: Tag/Badge + Timestamp
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        AppShimmerBox(
                          width: 26.w,
                          height: 2.2.h,
                          borderRadius: AppRadius.circular6,
                        ),
                        AppShimmerBox(
                          width: 18.w,
                          height: 1.6.h,
                          borderRadius: AppRadius.circular4,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.6.h),

                    // Title
                    AppShimmerBox(
                      width: 75.w,
                      height: 2.4.h,
                      borderRadius: AppRadius.circular6,
                    ),
                    SizedBox(height: 1.h),

                    // Content Lines
                    AppShimmerBox(
                      width: double.infinity,
                      height: 1.4.h,
                      borderRadius: AppRadius.circular4,
                    ),
                    SizedBox(height: 0.6.h),
                    AppShimmerBox(
                      width: 80.w,
                      height: 1.4.h,
                      borderRadius: AppRadius.circular4,
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
}
