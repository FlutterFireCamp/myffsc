import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/auth.dart';

class DashboardPage extends StatelessWidget {
  final UserEntity? user;
  final VoidCallback? onNavigateToPrograms;
  final VoidCallback? onNavigateToAnnouncements;
  final VoidCallback? onNavigateToForms;
  final VoidCallback? onNavigateToTests;

  const DashboardPage({
    super.key,
    this.user,
    this.onNavigateToPrograms,
    this.onNavigateToAnnouncements,
    this.onNavigateToForms,
    this.onNavigateToTests,
  });

  String _getLevelName(int level) {
    switch (level) {
      case 1:
        return "Niveau 1 • Dart & Algo";
      case 2:
        return "Niveau 2 • Flutter & UI";
      case 3:
        return "Niveau 3 • State & Firebase";
      case 4:
        return "Niveau 4 • Capstone Project";
      default:
        return "Niveau $level • Immersion";
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = user ?? (authState is AuthenticatedState ? authState.user : null);

    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.skyBlue),
        ),
      );
    }

    final handlePrograms = onNavigateToPrograms ?? () => context.go(RoutePaths.programs);
    final handleAnnouncements = onNavigateToAnnouncements ?? () => context.go(RoutePaths.announcements);
    final handleForms = onNavigateToForms ?? () => context.go(RoutePaths.forms);
    final handleTests = onNavigateToTests ?? () => context.go(RoutePaths.tests);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.flutterBlue,
              backgroundImage: currentUser.photoUrl != null ? NetworkImage(currentUser.photoUrl!) : null,
              child: currentUser.photoUrl == null
                  ? Text(
                      currentUser.firstName.isNotEmpty ? currentUser.firstName[0].toUpperCase() : 'A',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Salut, ${currentUser.firstName} 👋🏾",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  "Apprenant FFSC 💙☀️",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 9.sp,
                    color: AppColors.textSecondary,
                  ),
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
              color: AppColors.firebaseOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.firebaseOrange, width: 1),
            ),
            child: Row(
              children: [
                const Icon(AppIcons.star, size: 16, color: AppColors.firebaseYellow),
                SizedBox(width: 1.w),
                Text(
                  "${currentUser.totalPoints} pts",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.firebaseYellow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                borderRadius: BorderRadius.circular(20),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getLevelName(currentUser.level),
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.skyBlue,
                          ),
                        ),
                      ),
                      const Icon(AppIcons.badge, color: AppColors.skyBlue),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Immersion Totale & Mentorat",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.8.h),
                  Text(
                    "3 mois pour propulser les futurs leaders de la tech en Afrique Francophone.",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton.icon(
                    onPressed: handlePrograms,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.skyBlue,
                      foregroundColor: AppColors.ultraDark,
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(AppIcons.programs, size: 18, color: AppColors.ultraDark),
                    label: Text(
                      "Accéder aux Cours",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Next Live Session Card
            Text(
              "Prochaine Session Live 🎥",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 1.5.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
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
                    child: const Icon(AppIcons.video, color: AppColors.actionBlue),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Architecture Clean & BLoC Pattern",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            const Icon(AppIcons.calendar, size: 14, color: AppColors.textMuted),
                            SizedBox(width: 1.w),
                            Text(
                              "Mercredi 18:00 GMT • Mentor FFSC",
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 9.sp,
                                color: AppColors.textMuted,
                              ),
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

            // Quick Actions Grid
            Text(
              "Aujourd'hui dans le Camp ⚡",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 1.5.h),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    title: "Annonces",
                    subtitle: "Fil d'actualité",
                    icon: AppIcons.announcements,
                    color: AppColors.skyBlue,
                    onTap: handleAnnouncements,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _QuickActionCard(
                    title: "Formulaires",
                    subtitle: "Standups & Projets",
                    icon: AppIcons.forms,
                    color: AppColors.firebaseOrange,
                    onTap: handleForms,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    title: "Tests & Quiz",
                    subtitle: "Évaluations",
                    icon: AppIcons.tests,
                    color: AppColors.correctText,
                    onTap: handleTests,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _QuickActionCard(
                    title: "Programme",
                    subtitle: "Modules & Replays",
                    icon: AppIcons.programs,
                    color: AppColors.actionBlue,
                    onTap: handlePrograms,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            SizedBox(height: 1.5.h),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 0.3.h),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 9.sp,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
