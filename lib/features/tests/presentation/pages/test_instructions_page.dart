import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/test_quiz_entity.dart';
import 'test_taking_page.dart';

class TestInstructionsPage extends StatelessWidget {
  final TestQuizEntity quiz;

  const TestInstructionsPage({
    super.key,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Consignes de l'Examen"),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quiz Banner Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: AppRadius.circular16,
                        border: Border.all(
                          color: AppColors.actionBlue.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 0.6.h),
                                decoration: BoxDecoration(
                                  color: AppColors.actionBlue
                                      .withValues(alpha: 0.15),
                                  borderRadius: AppRadius.circular8,
                                  border: Border.all(
                                      color: AppColors.actionBlue
                                          .withValues(alpha: 0.4)),
                                ),
                                child: Text(
                                  "EXAMEN OFFICIEL",
                                  style: AppTextStyles.badgeSmall.copyWith(
                                    color: AppColors.skyBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${quiz.totalPoints} Pts",
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.firebaseYellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.8.h),
                          Text(
                            quiz.title,
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            quiz.description,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 2.h),

                          // Badges Row
                          Wrap(
                            spacing: 3.w,
                            runSpacing: 1.h,
                            children: [
                              _buildMetaBadge(
                                icon: AppIcons.timer(
                                    size: 16, color: AppColors.skyBlue),
                                label: "${quiz.totalDurationMinutes} Minutes",
                              ),
                              _buildMetaBadge(
                                icon: AppIcons.forms(
                                    size: 16, color: AppColors.firebaseYellow),
                                label: "${quiz.questions.length} Questions",
                              ),
                              _buildMetaBadge(
                                icon: AppIcons.info(
                                    size: 16, color: AppColors.correctText),
                                label: quiz.avgTimePerQuestionText,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5.h),

                    // Local Availability Time Window Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.cardHover,
                        borderRadius: AppRadius.circular12,
                        border: Border.all(
                          color: AppColors.firebaseOrange.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.5.w),
                            decoration: BoxDecoration(
                              color: AppColors.firebaseOrange
                                  .withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: AppIcons.calendar(
                              color: AppColors.firebaseOrange,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 3.5.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Plage Horaire d'Accessibilité",
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.4.h),
                                Text(
                                  quiz.localAvailabilityRangeText,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.firebaseYellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Instructions Title
                    Text(
                      "Consignes & Règlement Importants",
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 1.5.h),

                    // Rule 1: No Backward Navigation
                    _buildRuleCard(
                      icon: AppIcons.warning(
                          size: 20, color: AppColors.alertRed),
                      title: "Pas de retour en arrière",
                      description:
                          "Une fois que vous validez une question et passez à la suivante, il est strictement impossible de revenir en arrière.",
                    ),
                    SizedBox(height: 1.5.h),

                    // Rule 2: Timing & Bonus Time
                    _buildRuleCard(
                      icon: AppIcons.timer(
                          size: 20, color: AppColors.skyBlue),
                      title: "Gestion du temps & Décompte global",
                      description:
                          "Le chronomètre total descend en temps réel. Si vous répondez rapidement aux questions QCM, le temps économisé sera conservé pour les questions pratiques ou écrites à la fin.",
                    ),
                    SizedBox(height: 1.5.h),

                    // Rule 3: Anti Screenshot Protection
                    _buildRuleCard(
                      icon: AppIcons.lock(
                          size: 20, color: const Color(0xFFA5B4FC)),
                      title: "Protection Anti-Capture d'Écran",
                      description:
                          "Le système sécurisé de l'application bloque automatiquement les captures d'écran et les enregistrements vidéos de l'examen.",
                    ),
                    SizedBox(height: 1.5.h),

                    // Rule 4: No Copy Paste
                    _buildRuleCard(
                      icon: AppIcons.cancel(
                          size: 20, color: AppColors.warningAmber),
                      title: "Copier-Coller Désactivé",
                      description:
                          "La sélection de texte, la copie et le collage d'éléments externes sont totalement désactivés durant toute la durée du test.",
                    ),
                    SizedBox(height: 1.5.h),

                    // Rule 5: AI Content Detection
                    _buildRuleCard(
                      icon: AppIcons.star(
                          size: 20, color: AppColors.correctText),
                      title: "Détection Automatique d'IA",
                      description:
                          "Les contenus générés ou assistés par une intelligence artificielle sont automatiquement détectés et disqualifieront l'épreuve.",
                    ),
                    SizedBox(height: 2.5.h),
                  ],
                ),
              ),
            ),

            // Bottom Start Button Container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: const BoxDecoration(
                color: AppColors.card,
                border: Border(
                  top: BorderSide(color: AppColors.borderSubtle, width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => TestTakingPage(quiz: quiz),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    backgroundColor: AppColors.actionBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.circular14,
                    ),
                    elevation: 0,
                  ),
                  icon: AppIcons.arrowRight(color: Colors.white, size: 20),
                  label: Text(
                    "Commencer l'examen",
                    style: AppTextStyles.button.copyWith(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaBadge({required Widget icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: AppColors.ultraDark,
        borderRadius: AppRadius.circular8,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 1.8.w),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard({
    required Widget icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular12,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppColors.ultraDark,
              borderRadius: AppRadius.circular8,
            ),
            child: icon,
          ),
          SizedBox(width: 3.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
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
