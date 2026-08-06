import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class LevelConfig {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradientColors;

  const LevelConfig({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradientColors,
  });

  static LevelConfig fromLevel(int level) {
    switch (level) {
      case 1:
        return const LevelConfig(
          title: "Niveau 1 - Logique avec Dart 🎯",
          subtitle: "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "🎯",
          gradientColors: [Color(0xFF02569B), Color(0xFF013A63)],
        );
      case 2:
        return const LevelConfig(
          title: "Niveau 2 - UI/UX avec Flutter 💙",
          subtitle: "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "💙",
          gradientColors: [Color(0xFF02569B), Color(0xFF01B5F8)],
        );
      case 3:
        return const LevelConfig(
          title: "Niveau 3 - Intégration Firebase 🔥",
          subtitle: "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "🔥",
          gradientColors: [Color(0xFFFF8F00), Color(0xFFFF6F00)],
        );
      case 4:
      default:
        return const LevelConfig(
          title: "Niveau 4 - Projet de Fin du Camp 💎",
          subtitle: "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "💎",
          gradientColors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
        );
    }
  }

  static int calculateProgressPercentage(int level, int totalPoints) {
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
}

class DashboardHeaderBanner extends StatelessWidget {
  final int userLevel;
  final int totalPoints;
  final VoidCallback onActionTap;

  const DashboardHeaderBanner({
    super.key,
    required this.userLevel,
    required this.totalPoints,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressPct = LevelConfig.calculateProgressPercentage(userLevel, totalPoints);
    final levelConfig = LevelConfig.fromLevel(userLevel);

    return Container(
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
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: AppRadius.circular10,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                ),
                child: Text(
                  levelConfig.title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              Text(
                levelConfig.emoji,
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            "Ravis de te revoir !",
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 0.6.h),
          Text(
            levelConfig.subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.normal,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 2.5.h),

          // Progress Bar Header
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
        ],
      ),
    );
  }
}
