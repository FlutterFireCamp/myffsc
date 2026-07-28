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
            AppSnackBar.showError(context, state.message);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoadingState;

            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(),
                              SizedBox(
                                height: 22.h,
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
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
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
                                          disabledBackgroundColor: AppColors.skyBlue.withValues(alpha: 0.65),
                                          disabledForegroundColor: AppColors.ultraDark,
                                          padding: EdgeInsets.symmetric(vertical: 1.8.h),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: AppRadius.circular14,
                                          ),
                                          elevation: 2,
                                        ),
                                        child: isLoading
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 22,
                                                    height: 22,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      color: AppColors.ultraDark,
                                                    ),
                                                  ),
                                                  SizedBox(width: 3.w),
                                                  Text(
                                                    "Connexion en cours...",
                                                    style: AppTextStyles.button.copyWith(
                                                      color: AppColors.ultraDark,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  AppIcons.google(
                                                    color: AppColors.ultraDark,
                                                    size: AppSizes.iconMd,
                                                  ),
                                                  SizedBox(width: 3.w),
                                                  Text(
                                                    "Continuer avec Google",
                                                    style: AppTextStyles.button.copyWith(
                                                      color: AppColors.ultraDark,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
