import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;

    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.skyBlue),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Profil Apprenant"),
      ),
      body: ListView(
        primary: false,
        padding: EdgeInsets.all(5.w),
        children: [
          SizedBox(height: 2.h),

          // User Card Header
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular20,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.flutterBlue,
                  backgroundImage: currentUser.photoUrl != null ? NetworkImage(currentUser.photoUrl!) : null,
                  child: currentUser.photoUrl == null
                      ? Text(
                          currentUser.firstName.isNotEmpty ? currentUser.firstName[0].toUpperCase() : 'A',
                          style: AppTextStyles.h1.copyWith(color: Colors.white),
                        )
                      : null,
                ),
                SizedBox(height: 1.5.h),
                Text(
                  currentUser.name,
                  style: AppTextStyles.h3,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  currentUser.email,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),

          // Metrics Summary Card
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular16,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricItem(
                  title: "Niveau",
                  value: "Niveau ${currentUser.level}",
                  icon: AppIcons.badge(color: AppColors.skyBlue, size: AppSizes.iconLg),
                ),
                Container(width: 1, height: 40, color: AppColors.borderSubtle),
                _MetricItem(
                  title: "Points FFSC",
                  value: "${currentUser.totalPoints} pts",
                  icon: AppIcons.star(color: AppColors.firebaseYellow, size: AppSizes.iconLg),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Profile Options
          _ProfileTile(
            icon: AppIcons.announcements(color: AppColors.skyBlue, size: AppSizes.iconMd),
            title: "Notifications & Rappels",
            subtitle: "Gérer les alertes des cours et lives",
            onTap: () {},
          ),
          SizedBox(height: 1.5.h),
          _ProfileTile(
            icon: AppIcons.forms(color: AppColors.actionBlue, size: AppSizes.iconMd),
            title: "Historique des Soumissions",
            subtitle: "Voir vos formulaires envoyés",
            onTap: () {},
          ),
          SizedBox(height: 1.5.h),
          _ProfileTile(
            icon: AppIcons.logout(color: AppColors.errorText, size: AppSizes.iconMd),
            title: "Déconnexion",
            subtitle: "Se déconnecter du compte Google",
            isDestructive: true,
            onTap: () {
              AppConfirmationDialog.show(
                context,
                title: "Déconnexion",
                message: "Êtes-vous sûr de vouloir vous déconnecter du Portail Apprenant FFSC ?",
                confirmText: "Se déconnecter",
                cancelText: "Annuler",
                isDestructive: true,
                onConfirm: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 0.3.h),
        Text(
          title,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circular16,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.incorrectContainer : AppColors.card,
          borderRadius: AppRadius.circular16,
          border: Border.all(
            color: isDestructive ? AppColors.incorrectBorder : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.alertRed.withValues(alpha: 0.15)
                    : AppColors.actionBlue.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular10,
              ),
              child: icon,
            ),
            SizedBox(width: 3.5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isDestructive ? AppColors.errorText : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDestructive ? AppColors.alertRed.withValues(alpha: 0.8) : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AppIcons.arrowRight(
              color: isDestructive ? AppColors.errorText : AppColors.textMuted,
              size: AppSizes.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}
