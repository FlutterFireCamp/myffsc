import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class TestsShimmer extends StatelessWidget {
  const TestsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      children: [
        // Active Quiz Card Skeleton
        AppShimmer(
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular20,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 25.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardHover,
                        borderRadius: AppRadius.circular8,
                      ),
                    ),
                    Container(
                      width: 18.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardHover,
                        borderRadius: AppRadius.circular8,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Container(
                  width: 70.w,
                  height: 2.5.h,
                  decoration: BoxDecoration(
                    color: AppColors.cardHover,
                    borderRadius: AppRadius.circular6,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 90.w,
                  height: 1.8.h,
                  decoration: BoxDecoration(
                    color: AppColors.cardHover,
                    borderRadius: AppRadius.circular6,
                  ),
                ),
                SizedBox(height: 3.h),
                Container(
                  width: double.infinity,
                  height: 5.5.h,
                  decoration: BoxDecoration(
                    color: AppColors.cardHover,
                    borderRadius: AppRadius.circular12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
