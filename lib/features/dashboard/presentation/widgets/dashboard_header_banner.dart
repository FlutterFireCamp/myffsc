import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class LevelConfig {
  final String title;
  final String subtitle;
  final String emoji;
  final Color levelColor;

  const LevelConfig({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.levelColor,
  });

  static LevelConfig fromLevel(int level) {
    switch (level) {
      case 1:
        return const LevelConfig(
          title: "Niveau 1 - Logique avec Dart",
          subtitle:
              "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "🎯",
          levelColor: AppColors.skyBlue,
        );
      case 2:
        return const LevelConfig(
          title: "Niveau 2 - UI/UX avec Flutter",
          subtitle:
              "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "💙",
          levelColor: AppColors.skyBlue,
        );
      case 3:
        return const LevelConfig(
          title: "Niveau 3 - Intégration Firebase",
          subtitle:
              "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "🔥",
          levelColor: AppColors.warningAmber,
        );
      case 4:
      default:
        return const LevelConfig(
          title: "Niveau 4 - Projet de Fin du Camp",
          subtitle:
              "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "💎",
          levelColor: AppColors.purpleConference,
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
    final progressPct = LevelConfig.calculateProgressPercentage(
      userLevel,
      totalPoints,
    );
    final levelConfig = LevelConfig.fromLevel(userLevel);
    final levelColor = levelConfig.levelColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular20,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // Level Title Badge & Level Emoji
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.5.w,
                  vertical: 0.7.h,
                ),
                decoration: BoxDecoration(
                  color: levelColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular10,
                  border: Border.all(color: levelColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  levelConfig.title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: levelColor,
                    fontWeight: .bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: levelColor.withValues(alpha: 0.15),
                  shape: .circle,
                  border: Border.all(color: levelColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  levelConfig.emoji,
                  style: AppTextStyles.titleMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          Text(
            "Ravis de te revoir !",
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 0.6.h),
          Text(
            levelConfig.subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),

          // Progress Bar Header
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Progression Globale",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: .w600,
                ),
              ),
              Text(
                "$progressPct%",
                style: AppTextStyles.titleMedium.copyWith(
                  color: levelColor,
                  fontWeight: .bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // Progress Bar
          ClipRRect(
            borderRadius: AppRadius.circular10,
            child: Container(
              height: 8,
              width: double.infinity,
              color: AppColors.ultraDark,
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: (progressPct / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: levelColor,
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
