import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class AnnouncementsShimmer extends StatelessWidget {
  const AnnouncementsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: 4,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) => Container(
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
              SizedBox(height: 0.8.h),
              AppShimmerBox(
                width: 70.w,
                height: 1.4.h,
                borderRadius: AppRadius.circular4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
