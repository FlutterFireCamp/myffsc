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
        child: ListView(
          primary: false,
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Column(
                children: [
                  SizedBox(
                    height: 24.h,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            "FFSC",
                            style: AppTextStyles.h1.copyWith(
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
                          text: "Flutter",
                          style: AppTextStyles.heroTitle.copyWith(
                            color: const Color(0xFF0288D1),
                          ),
                        ),
                        TextSpan(
                          text: "Fire\n",
                          style: AppTextStyles.heroTitle.copyWith(
                            color: AppColors.firebaseOrange,
                          ),
                        ),
                        TextSpan(
                          text: "Summer ",
                          style: AppTextStyles.heroSubtitle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFCA28),
                          ),
                        ),
                        TextSpan(
                          text: "Camp 💙☀️",
                          style: AppTextStyles.heroSubtitle.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.2.h),
                  Text(
                    "Portail Apprenant",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),

            // Access Verification Section (No card box, thin progress bar)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  SizedBox(
                    width: 55.w,
                    child: ClipRRect(
                      borderRadius: AppRadius.circular8,
                      child: const LinearProgressIndicator(
                        minHeight: 2,
                        backgroundColor: AppColors.ultraDark,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.skyBlue),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Vérification de votre accès...",
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
      ),
    );
  }
}
