import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class AccessCheckingPage extends StatelessWidget {
  const AccessCheckingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Centered App Logo
              SizedBox(
                height: 22.h,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        "FFSC",
                        style: AppTextStyles.heroTitle.copyWith(
                          color: AppColors.skyBlue,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 2.5.h),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "FlutterFire ",
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.skyBlue,
                      ),
                    ),
                    TextSpan(
                      text: "Summer Camp",
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              // Bottom Progress & Verification Text
              SizedBox(
                width: 45.w,
                child: ClipRRect(
                  borderRadius: AppRadius.circular8,
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: AppColors.ultraDark,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.skyBlue,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Vérification...",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
