import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_metrics_card.dart';
import '../widgets/profile_social_links_bar.dart';
import '../widgets/profile_test_history_section.dart';

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
        title: const Text("Profil"),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 3.w),
            decoration: BoxDecoration(
              color: AppColors.errorText.withValues(alpha: 0.15),
              borderRadius: AppRadius.circular12,
              border: Border.all(
                color: AppColors.errorText.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: IconButton(
              tooltip: "Se déconnecter",
              padding: EdgeInsets.all(2.w),
              constraints: const BoxConstraints(),
              icon: AppIcons.logout(color: AppColors.errorText, size: 18),
              onPressed: () {
                AppConfirmationDialog.show(
                  context,
                  title: "Déconnexion",
                  message:
                      "Êtes-vous sûr de vouloir vous déconnecter du Portail Apprenant FFSC ?",
                  confirmText: "Se déconnecter",
                  cancelText: "Annuler",
                  isDestructive: true,
                  onConfirm: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: ListView(
        primary: false,
        padding: EdgeInsets.all(5.w),
        children: [
          SizedBox(height: 0.5.h),

          // 1. User Header Card (Photo, Name, Email, Badges + Edit Button)
          ProfileHeaderCard(user: currentUser),
          SizedBox(height: 2.5.h),

          // 2. Social Links Bar
          ProfileSocialLinksBar(user: currentUser),

          // 3. Metrics Summary Card (Level & Points)
          ProfileMetricsCard(user: currentUser),
          SizedBox(height: 3.h),

          // 4. Test History Section (Matches image design)
          ProfileTestHistorySection(userId: currentUser.id),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}
