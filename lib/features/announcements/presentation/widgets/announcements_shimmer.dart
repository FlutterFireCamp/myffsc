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
        // Filter Chips Row Skeleton
        AppShimmer(
          child: Row(
            children: List.generate(
              3,
              (i) => Container(
                margin: EdgeInsets.only(right: 2.w),
                width: 28.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular12,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.5.h),

        // Announcement Cards Skeletons
        ...List.generate(
          2,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: AppShimmer(
              child: Container(
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
