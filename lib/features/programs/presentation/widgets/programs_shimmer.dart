import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class ProgramsShimmer extends StatelessWidget {
  const ProgramsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      children: [
        // Filter Chips Row Skeleton
        AppShimmer(
          child: Row(
            spacing: 2.w,
            children: List.generate(
              3,
              (i) => Container(
                width: 25.w,
                height: 4.h,
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular12,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.5.h),

        // Program Cards Skeletons
        ...List.generate(
          2,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: AppShimmer(
              child: Container(
                height: 18.h,
                decoration: const BoxDecoration(
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
