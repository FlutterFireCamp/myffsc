import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class ProgramsShimmer extends StatelessWidget {
  const ProgramsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: 4,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) => Container(
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
              // Top: Circle Icon + Badge + Title
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

              // Date Row
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

              // Action Buttons Row
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
    );
  }
}
