import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class UnauthorizedPage extends StatelessWidget {
  final UserEntity? user;

  const UnauthorizedPage({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = user ?? (authState is UnauthorizedState ? authState.user : null);

    final emailText = currentUser?.email ?? 'votre compte';
    final statusText = currentUser?.status == 'pending'
        ? 'En attente de validation'
        : currentUser?.status == 'suspended'
            ? 'Compte suspendu'
            : 'Non autorisé';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Warning Icon Container
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.incorrectContainer,
                  border: Border.all(color: AppColors.incorrectBorder, width: 2),
                ),
                child: Center(
                  child: AppIcons.lock(
                    size: 10.w,
                    color: AppColors.errorText,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "Accès Non Autorisé",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.errorText,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "Votre compte ($emailText) n'a pas la permission d'accéder au portail My FFSC.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 3.h),

              // Status Details Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Statut Actuel :",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 11.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                          decoration: BoxDecoration(
                            color: AppColors.warningAmber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.warningAmber),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warningAmber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    const Divider(color: AppColors.borderSubtle),
                    SizedBox(height: 2.h),
                    Text(
                      "Si vous êtes un apprenant sélectionné pour cette cohorte du FlutterFire Summer Camp, veuillez contacter les mentors sur Discord ou WhatsApp pour faire valider votre accès.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Logout Button
              OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                  side: const BorderSide(color: AppColors.borderSubtle),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: AppIcons.logout(color: AppColors.textSecondary, size: 20),
                label: Text(
                  "Se déconnecter",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
