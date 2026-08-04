import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../programs/domain/entities/program_item.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ProgramItem? _todayProgram;
  bool _isLoadingTodayProgram = true;

  @override
  void initState() {
    super.initState();
    _fetchTodayProgram();
  }

  Future<void> _fetchTodayProgram() async {
    try {
      final querySnapshot = await _firestore
          .collection('programs')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _todayProgram = ProgramItem.fromFirestore(querySnapshot.docs.first);
        });
      }
    } catch (e) {
      debugPrint('Error fetching today program: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTodayProgram = false;
        });
      }
    }
  }

  Future<void> _launchExternalUrl(String? urlString) async {
    if (urlString == null || urlString.trim().isEmpty) return;
    final Uri url = Uri.parse(urlString.startsWith('http') ? urlString : 'https://$urlString');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Impossible d'ouvrir le lien : $urlString"),
              backgroundColor: AppColors.incorrectContainer,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'ouverture : $e"),
            backgroundColor: AppColors.incorrectContainer,
          ),
        );
      }
    }
  }

  int _getUserProgressPercentage(int level, int totalPoints) {
    final points = totalPoints < 0 ? 0 : totalPoints;

    if (level == 1) {
      final ratio = (points / 100).clamp(0.0, 1.0);
      return (0 + ratio * 30).round();
    } else if (level == 2) {
      final ptsInLevel = (points - 100) < 0 ? 0 : (points - 100);
      final ratio = (ptsInLevel / 200).clamp(0.0, 1.0);
      return (31 + ratio * 29).round();
    } else if (level == 3) {
      final ptsInLevel = (points - 300) < 0 ? 0 : (points - 300);
      final ratio = (ptsInLevel / 300).clamp(0.0, 1.0);
      return (61 + ratio * 19).round();
    } else if (level >= 4) {
      return 100;
    }
    return 0;
  }

  _LevelConfig _getLevelConfig(int level) {
    switch (level) {
      case 1:
        return const _LevelConfig(
          title: "Niveau 1 - Logique avec Dart 🎯",
          subtitle: "Fondations Dart & Logique de programmation",
          emoji: "🎯",
          gradientColors: [Color(0xFF02569B), Color(0xFF013A63)],
        );
      case 2:
        return const _LevelConfig(
          title: "Niveau 2 - UI/UX avec Flutter 💙",
          subtitle: "Développement Mobile Cross-Platform & UI",
          emoji: "💙",
          gradientColors: [Color(0xFF02569B), Color(0xFF01B5F8)],
        );
      case 3:
        return const _LevelConfig(
          title: "Niveau 3 - Intégration Firebase 🔥",
          subtitle: "Backend Serverless, Auth & Firestore",
          emoji: "🔥",
          gradientColors: [Color(0xFFFF8F00), Color(0xFFFF6F00)],
        );
      case 4:
      default:
        return const _LevelConfig(
          title: "Niveau 4 - Projet de Fin du Camp 💎",
          subtitle: "Projet final & Attestation de réussite",
          emoji: "💎",
          gradientColors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
        );
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

    final progressPct = _getUserProgressPercentage(currentUser.level, currentUser.totalPoints);
    final levelConfig = _getLevelConfig(currentUser.level);

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
          // Custom Level Header Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: levelConfig.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.circular20,
              boxShadow: [
                BoxShadow(
                  color: levelConfig.gradientColors.first.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.7.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: AppRadius.circular10,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: Text(
                        levelConfig.title,
                        style: AppTextStyles.badge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9.5.sp,
                        ),
                      ),
                    ),
                    Text(
                      levelConfig.emoji,
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  "Immersion Totale & Mentorat",
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  levelConfig.subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 2.5.h),

                // Progress Bar Header (Label + Percentage)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Progression Globale",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$progressPct%",
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),

                // Progress Bar
                ClipRRect(
                  borderRadius: AppRadius.circular10,
                  child: Container(
                    height: 10,
                    width: double.infinity,
                    color: Colors.black.withValues(alpha: 0.25),
                    child: Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: (progressPct / 100).clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.white, Color(0xFFE0F2FE)],
                              ),
                              borderRadius: AppRadius.circular10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.5.h),

                // Action Button
                ElevatedButton.icon(
                  onPressed: handlePrograms,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.ultraDark,
                    padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.4.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.circular12,
                    ),
                    elevation: 0,
                  ),
                  icon: AppIcons.programs(size: AppSizes.iconMd, color: AppColors.ultraDark),
                  label: Text(
                    "Accéder aux Cours",
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: AppColors.ultraDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Programme du Jour (Realtime from Firebase)
          Text(
            "Programme du Jour",
            style: AppTextStyles.titleLarge,
          ),
          SizedBox(height: 1.5.h),
          _isLoadingTodayProgram
              ? const AppShimmer(child: AppCardShimmer())
              : _todayProgram == null
                  ? const AppEmptyState(
                      title: "Aucun programme prévu aujourd'hui",
                      message: "Consultez l'onglet Programmes pour découvrir les prochaines sessions.",
                    )
                  : _buildTodayProgramCard(_todayProgram!),
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

  Widget _buildTodayProgramCard(ProgramItem program) {
    final hasLive = program.sessionUrl != null && program.sessionUrl!.trim().isNotEmpty;
    final hasReplay = program.replayUrl != null && program.replayUrl!.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppColors.actionBlue.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: AppIcons.video(color: AppColors.actionBlue, size: 24),
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                      decoration: BoxDecoration(
                        color: AppColors.actionBlue.withValues(alpha: 0.12),
                        borderRadius: AppRadius.circular6,
                      ),
                      child: Text(
                        program.type.label,
                        style: AppTextStyles.badge.copyWith(
                          color: AppColors.actionBlue,
                          fontSize: 8.5.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      program.title,
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 0.3.h),
                    Row(
                      children: [
                        AppIcons.calendar(size: 13, color: AppColors.textMuted),
                        SizedBox(width: 1.w),
                        Text(
                          "${program.date} ${program.time.isNotEmpty ? '• ${program.time}' : ''}",
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasLive || hasReplay) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                if (hasLive)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _launchExternalUrl(program.sessionUrl),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.skyBlue),
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular10,
                        ),
                      ),
                      icon: AppIcons.video(size: AppSizes.iconSm, color: AppColors.skyBlue),
                      label: Text(
                        "Rejoindre Live",
                        style: AppTextStyles.buttonSmall.copyWith(color: AppColors.skyBlue),
                      ),
                    ),
                  ),
                if (hasLive && hasReplay) SizedBox(width: 2.w),
                if (hasReplay)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _launchExternalUrl(program.replayUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ultraDark,
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular10,
                        ),
                      ),
                      icon: AppIcons.video(size: AppSizes.iconSm, color: AppColors.textPrimary),
                      label: Text(
                        "Replay",
                        style: AppTextStyles.buttonSmall.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LevelConfig {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradientColors;

  const _LevelConfig({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradientColors,
  });
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
