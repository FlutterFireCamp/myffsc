import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LevelConfig {
  final int level;
  final String title;
  final String subtitle;
  final String emoji;
  final Color levelColor;

  const LevelConfig({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.levelColor,
  });

  static LevelConfig fromLevel(int level) {
    final color = AppColors.getLevelColor(level);
    switch (level) {
      case 1:
        return LevelConfig(
          level: 1,
          title: "Niveau 1 - Logique avec Dart",
          subtitle:
              "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "🎯",
          levelColor: color,
        );
      case 2:
        return LevelConfig(
          level: 2,
          title: "Niveau 2 - UI/UX avec Flutter",
          subtitle:
              "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "💙",
          levelColor: color,
        );
      case 3:
        return LevelConfig(
          level: 3,
          title: "Niveau 3 - Intégration Firebase",
          subtitle:
              "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "🔥",
          levelColor: color,
        );
      case 4:
      default:
        return LevelConfig(
          level: 4,
          title: "Niveau 4 - Projet de Fin du Camp",
          subtitle:
              "Poursuivez votre apprentissage pour valider votre cohorte 2026.",
          emoji: "💎",
          levelColor: color,
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
