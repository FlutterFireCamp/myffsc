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
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          child: Column(
                            mainAxisAlignment: .center,
                            crossAxisAlignment: .center,
                            children: [
                              const Spacer(),
                              SizedBox(
                                height: 22.h,
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
                                      style: AppTextStyles.heroSubtitle
                                          .copyWith(
                                            fontWeight: .bold,
                                            color: AppColors.firebaseYellow,
                                          ),
                                    ),
                                    TextSpan(
                                      text: "Camp 💙☀️",
                                      style: AppTextStyles.heroSubtitle
                                          .copyWith(
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
                              SizedBox(height: 3.h),

                              // Authentication Box
                              Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: AppRadius.circular20,
                                  border: Border.all(
                                    color: AppColors.borderSubtle,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: .stretch,
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
                                            : () async {
                                                final isOnline =
                                                    await NetworkHelper.checkConnection(
                                                      context,
                                                    );
                                                if (!isOnline) return;
                                                if (context.mounted) {
                                                  context.read<AuthBloc>().add(
                                                    SignInWithGoogleRequested(),
                                                  );
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.skyBlue,
                                          foregroundColor: Colors.white,
                                          disabledBackgroundColor: AppColors
                                              .skyBlue
                                              .withValues(alpha: 0.65),
                                          disabledForegroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 1.8.h,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: AppRadius.circular14,
                                          ),
                                          elevation: 2,
                                        ),
                                        child: isLoading
                                            ? Row(
                                                mainAxisAlignment: .center,
                                                spacing: 3.w,
                                                children: [
                                                  const SizedBox(
                                                    width: 22,
                                                    height: 22,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2.5,
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                  Text(
                                                    "Connexion en cours...",
                                                    style: AppTextStyles.button
                                                        .copyWith(
                                                          color: Colors.white,
                                                          fontWeight: .bold,
                                                        ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment: .center,
                                                spacing: 3.w,
                                                children: [
                                                  AppIcons.google(
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  Text(
                                                    "Continuer avec Google",
                                                    style: AppTextStyles.button
                                                        .copyWith(
                                                          color: Colors.white,
                                                          fontWeight: .bold,
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
