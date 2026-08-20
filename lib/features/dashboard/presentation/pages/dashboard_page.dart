import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/dashboard_header_banner.dart';
import '../widgets/quick_action_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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

    void handlePrograms() => context.go('/programs');
    void handleAnnouncements() => context.go('/announcements');
    void handleTests() => context.go('/tests');
    void handlePodium() => context.go('/podium');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          spacing: 3.w,
          children: [
            AppCachedAvatar(
              imageUrl: currentUser.photoUrl,
              radius: 20,
              fallbackInitial: currentUser.firstName,
              fallbackTextStyle: AppTextStyles.titleMedium,
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "Salut, ${currentUser.firstName} 👋🏾",
                  style: AppTextStyles.h3,
                ),
                Text("Apprenant FFSC 💙☀️", style: AppTextStyles.bodySmall),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
            decoration: BoxDecoration(
              color: AppColors.firebaseYellow.withValues(alpha: 0.15),
              borderRadius: AppRadius.circular12,
              border: Border.all(color: AppColors.firebaseYellow, width: 1),
            ),
            child: Row(
              spacing: 1.w,
              children: [
                const Text("🏆"),
                Text(
                  "${currentUser.totalPoints} pts",
                  style: AppTextStyles.badge.copyWith(
                    color: AppColors.firebaseYellow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
          // Header Level Progress Banner
          DashboardHeaderBanner(
            userLevel: currentUser.level,
            totalPoints: currentUser.totalPoints,
            onActionTap: handlePrograms,
          ),
          SizedBox(height: 3.h),

          // Quick Actions Grid Header
          Text(
            "Aujourd'hui dans le Camp",
            style: AppTextStyles.titleLarge,
          ),
          SizedBox(height: 1.5.h),

          // Row 1: Programmes & Annonces
          Row(
            spacing: 3.w,
            children: [
              Expanded(
                child: QuickActionCard(
                  title: "Programmes",
                  subtitle: "Agenda complet",
                  icon: AppIcons.programs(
                    color: AppColors.actionBlue,
                    size: AppSizes.iconLg,
                  ),
                  backgroundColor: AppColors.actionBlue,
                  onTap: handlePrograms,
                ),
              ),
              Expanded(
                child: QuickActionCard(
                  title: "Annonces",
                  subtitle: "Fil d'actualité",
                  icon: AppIcons.announcements(
                    color: AppColors.skyBlue,
                    size: AppSizes.iconLg,
                  ),
                  backgroundColor: AppColors.skyBlue,
                  onTap: handleAnnouncements,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),

          // Row 2: Évaluations & Podium
          Row(
            spacing: 3.w,
            children: [
              Expanded(
                child: QuickActionCard(
                  title: "Évaluations",
                  subtitle: "Tests du jour",
                  icon: AppIcons.tests(
                    color: AppColors.programTestBadge,
                    size: AppSizes.iconLg,
                  ),
                  backgroundColor: AppColors.programTestBadge,
                  onTap: handleTests,
                ),
              ),
              Expanded(
                child: QuickActionCard(
                  title: "Podium",
                  subtitle: "Classement général",
                  icon: AppIcons.podium(
                    color: AppColors.gold,
                    size: AppSizes.iconLg,
                  ),
                  backgroundColor: AppColors.gold,
                  onTap: handlePodium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
