import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_metrics_card.dart';
import '../widgets/profile_option_tile.dart';
import '../widgets/profile_social_links_bar.dart';
import 'edit_profile_page.dart';

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
          SizedBox(height: 1.h),

          // User Header Card
          ProfileHeaderCard(user: currentUser),
          SizedBox(height: 3.h),

          // Social Links Bar
          ProfileSocialLinksBar(user: currentUser),

          // Metrics Summary Card
          ProfileMetricsCard(user: currentUser),
          SizedBox(height: 3.h),

          // Profile Options Tiles
          ProfileOptionTile(
            icon: AppIcons.edit(color: AppColors.skyBlue, size: AppSizes.iconMd),
            title: "Modifier mon Profil",
            subtitle: "Changer vos coordonnées et vos liens sociaux",
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(user: currentUser),
                ),
              );
            },
          ),
          SizedBox(height: 1.5.h),
          ProfileOptionTile(
            icon: AppIcons.announcements(color: AppColors.skyBlue, size: AppSizes.iconMd),
            title: "Notifications & Rappels",
            subtitle: "Consulter les annonces, flashs et rappels",
            onTap: () {
              context.go('/announcements');
            },
          ),
          SizedBox(height: 1.5.h),
          ProfileOptionTile(
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
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}
