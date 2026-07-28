import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Tests & Quiz",
          style: AppTextStyles.h3,
        ),
      ),
      body: ListView(
        primary: false,
        padding: EdgeInsets.all(5.w),
        children: [
          SizedBox(height: 3.h),
          AppCard(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon with subtle red container
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.alertRed.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.alertRed.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: AppIcons.tests(
                    size: 36,
                    color: AppColors.alertRed,
                  ),
                ),
                SizedBox(height: 2.5.h),

                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.8.h),
                  decoration: BoxDecoration(
                    color: AppColors.ultraDark,
                    borderRadius: AppRadius.circular20,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.firebaseYellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "En attente d'activation",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.firebaseYellow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.5.h),

                // Title
                Text(
                  "Quiz Non Disponible",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h3,
                ),
                SizedBox(height: 1.2.h),

                // Message
                Text(
                  "Le quiz s'affiche ici une fois les admins vont ouvrir cela.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
