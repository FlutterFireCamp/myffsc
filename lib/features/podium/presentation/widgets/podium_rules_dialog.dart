import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class PodiumRulesDialog extends StatelessWidget {
  const PodiumRulesDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const PodiumRulesDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: AppColors.modalBackground,
          borderRadius: AppRadius.circular24,
          border: Border.all(color: AppColors.cardHover, width: 1.2),
        ),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: 1.2.h,
          children: [
            // Header Row: Trophy Icon + Title (Left) & Close (X) Button (Right)
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Row(
                  spacing: 2.5.w,
                  children: [
                    AppIcons.podium(color: AppColors.skyBlue, size: 24),
                    Text(
                      "Règles du Classement FFSC",
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: .circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            // Intro Subtitle
            Text(
              "Les positions du podium et du classement sont calculées selon 3 critères stricts :",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),

            // Criterion 1: Total Points (Gold)
            _buildRuleCard(
              icon: AppIcons.medalFirstPlace(color: AppColors.gold, size: 28),
              title: "Points totaux",
              titleColor: AppColors.gold,
              borderColor: AppColors.gold.withValues(alpha: 0.35),
              bgColor: AppColors.goldSurface,
              description:
                  "Décroissant : Le plus grand nombre de points passe devant.",
            ),

            // Criterion 2: Level (Silver)
            _buildRuleCard(
              icon: AppIcons.medalSecondPlace(
                color: AppColors.silver,
                size: 28,
              ),
              title: "Niveau",
              titleColor: AppColors.textSecondary,
              borderColor: AppColors.silver.withValues(alpha: 0.35),
              bgColor: AppColors.silverSurface,
              description:
                  "Décroissant : En cas d'égalité, le niveau prévaut (Niveau 3 > 2 > 1).",
            ),

            // Criterion 3: Response Time on Last Test (Bronze)
            _buildRuleCard(
              icon: AppIcons.medalThirdPlace(color: AppColors.bronze, size: 28),
              title: "Temps de Réponse au Dernier Test",
              titleColor: AppColors.bronze,
              borderColor: AppColors.bronze.withValues(alpha: 0.35),
              bgColor: AppColors.navySurface,
              description:
                  "Croissant : En cas d'égalité, la réponse la plus rapide prévaut.",
            ),

            // Dynamic Evolution Note Box
            Container(
              width: double.infinity,
              padding: .symmetric(horizontal: 3.5.w, vertical: 1.2.h),
              margin: .symmetric(vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withValues(alpha: 0.08),
                borderRadius: AppRadius.circular12,
                border: .all(
                  color: AppColors.skyBlue.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Évolution dynamique : ",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.skyBlue,
                        fontWeight: .bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          "Le classement est mis à jour en temps réel et peut évoluer au cours de la semaine.",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleCard({
    required Widget icon,
    required String title,
    required Color titleColor,
    required Color borderColor,
    required Color bgColor,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.circular14,
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: .start,
        spacing: 3.w,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.2.h),
            child: icon,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 0.3.h,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: titleColor,
                    fontWeight: .bold,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
