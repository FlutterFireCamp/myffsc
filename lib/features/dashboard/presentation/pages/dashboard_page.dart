import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _getLevelName(int level) {
    switch (level) {
      case 1:
        return "Niveau 1 • Débutant";
      case 2:
        return "Niveau 2 • Intermédiaire";
      case 3:
        return "Niveau 3 • Avancé";
      case 4:
        return "Niveau 4 • Capstone Pro";
      default:
        return "Niveau 1 • Débutant";
    }
  }

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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            AppCachedAvatar(
              imageUrl: currentUser.photoUrl,
              radius: 20,
              fallbackInitial: currentUser.firstName,
              fallbackTextStyle: AppTextStyles.titleMedium,
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Salut, ${currentUser.firstName} 👋🏾",
                  style: AppTextStyles.h3,
                ),
                Text(
                  "Apprenant FFSC 💙☀️",
                  style: AppTextStyles.bodySmall,
                ),
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
              children: [
                AppIcons.star(size: 18, color: AppColors.firebaseYellow),
                SizedBox(width: 1.w),
                Text(
                  "${currentUser.totalPoints} pts",
                  style: AppTextStyles.badge.copyWith(color: AppColors.firebaseYellow),
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
          // Banner Immersion Progress
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.flutterBlue, AppColors.ultraDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.circular20,
              border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                      decoration: BoxDecoration(
                        color: AppColors.skyBlue.withValues(alpha: 0.2),
                        borderRadius: AppRadius.circular8,
                      ),
                      child: Text(
                        _getLevelName(currentUser.level),
                        style: AppTextStyles.badge,
                      ),
                    ),
                    AppIcons.badge(color: AppColors.skyBlue, size: AppSizes.iconLg),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  "Immersion Totale & Mentorat",
                  style: AppTextStyles.h2,
                ),
                SizedBox(height: 0.8.h),
                Text(
                  "3 mois pour propulser les futurs leaders de la tech en Afrique Francophone.",
                  style: AppTextStyles.bodyMedium,
                ),
                SizedBox(height: 2.h),
                ElevatedButton.icon(
                  onPressed: handlePrograms,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.skyBlue,
                    foregroundColor: AppColors.ultraDark,
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.circular10,
                    ),
                  ),
                  icon: AppIcons.programs(size: AppSizes.iconMd, color: AppColors.ultraDark),
                  label: Text(
                    "Accéder aux Cours",
                    style: AppTextStyles.buttonSmall.copyWith(color: AppColors.ultraDark),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Next Live Session Card
          Text(
            "Prochaine Session Live",
            style: AppTextStyles.titleLarge,
          ),
          SizedBox(height: 1.5.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular16,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppColors.actionBlue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: AppIcons.video(color: AppColors.actionBlue, size: 26),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Architecture Clean & BLoC Pattern",
                        style: AppTextStyles.titleMedium,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          AppIcons.calendar(size: AppSizes.iconSm, color: AppColors.textMuted),
                          SizedBox(width: 1.w),
                          Text(
                            "Mercredi 18:00 GMT • Mentor FFSC",
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Quick Actions Grid (Programmes & Annonces)
          Text(
            "Aujourd'hui dans le Camp",
            style: AppTextStyles.titleLarge,
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  title: "Programmes",
                  subtitle: "Syllabus complet & cours",
                  icon: AppIcons.programs(color: AppColors.actionBlue, size: AppSizes.iconLg),
                  backgroundColor: AppColors.actionBlue,
                  onTap: handlePrograms,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _QuickActionCard(
                  title: "Annonces",
                  subtitle: "Fil d'actualité",
                  icon: AppIcons.announcements(color: AppColors.skyBlue, size: AppSizes.iconLg),
                  backgroundColor: AppColors.skyBlue,
                  onTap: handleAnnouncements,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
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
          color: AppColors.card,
          borderRadius: AppRadius.circular16,
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: backgroundColor.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular12,
              ),
              child: icon,
            ),
            SizedBox(height: 1.5.h),
            Text(
              title,
              style: AppTextStyles.titleMedium,
            ),
            SizedBox(height: 0.4.h),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
