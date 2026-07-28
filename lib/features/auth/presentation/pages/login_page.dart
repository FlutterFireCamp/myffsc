import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: AppTextStyles.bodyMedium),
                backgroundColor: AppColors.errorText,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoadingState;

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Section: Clean Logo Image (No circle border) & Titles
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 14.h,
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
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
                                    style: AppTextStyles.h1.copyWith(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0288D1),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Fire\n",
                                    style: AppTextStyles.h1.copyWith(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.firebaseOrange,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Summer ",
                                    style: AppTextStyles.h2.copyWith(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFFCA28),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Camp 💙☀️",
                                    style: AppTextStyles.h2.copyWith(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.normal,
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
                      SizedBox(height: 3.h),

                      // Authentication Box
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: AppRadius.circular20,
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Connexion", style: AppTextStyles.h3),
                            SizedBox(height: 1.2.h),
                            Text(
                              "Connectez-vous avec le compte Google associé à votre candidature du programme.",
                              style: AppTextStyles.bodySmall,
                            ),
                            SizedBox(height: 3.h),
                            ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.read<AuthBloc>().add(
                                        SignInWithGoogleRequested(),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.skyBlue,
                                foregroundColor: AppColors.ultraDark,
                                padding: EdgeInsets.symmetric(vertical: 1.8.h),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadius.circular14,
                                ),
                              ),
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.ultraDark,
                                      ),
                                    )
                                  : AppIcons.google(
                                      color: AppColors.ultraDark,
                                      size: AppSizes.iconMd,
                                    ),
                              label: Text(
                                isLoading
                                    ? "Connexion en cours..."
                                    : "Continuer avec Google",
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.ultraDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
