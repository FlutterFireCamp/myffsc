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
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                const Spacer(flex: 2),
                // Logo
                SizedBox(
                  height: 20.h,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: .contain,
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
                          color: AppColors.flutterLightBlue,
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
                          fontWeight: .bold,
                          color: AppColors.firebaseYellow,
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
                  textAlign: .center,
                ),
                SizedBox(height: 1.2.h),
                Text(
                  "Portail Apprenant",
                  textAlign: .center,
                  style: AppTextStyles.bodyMedium,
                ),
                const Spacer(flex: 2),

                // Thin Progress Bar & Text
                SizedBox(
                  width: 55.w,
                  child: ClipRRect(
                    borderRadius: AppRadius.circular8,
                    child: const LinearProgressIndicator(
                      minHeight: 2,
                      backgroundColor: AppColors.ultraDark,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.skyBlue,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.8.h),
                Text(
                  "Vérification de votre accès...",
                  textAlign: .center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
