import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/test_quiz_entity.dart';
import '../bloc/bloc.dart';
import '../widgets/instruction_rule_card.dart';
import 'test_taking_page.dart';

class TestInstructionsPage extends StatelessWidget {
  final TestQuizEntity quiz;

  const TestInstructionsPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Consignes & Règlement"),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                primary: false,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
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
                                horizontal: 3.w,
                                vertical: 0.6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.actionBlue.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: AppRadius.circular8,
                                border: Border.all(
                                  color: AppColors.actionBlue.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: Text(
                                "ÉVALUATION OFFICIELLE",
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
                                color: AppColors.skyBlue,
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
                                size: 16,
                                color: AppColors.skyBlue,
                              ),
                              label: "${quiz.totalDurationMinutes} Minutes",
                            ),
                            _buildMetaBadge(
                              icon: AppIcons.forms(
                                size: 16,
                                color: AppColors.skyBlue,
                              ),
                              label: "${quiz.questions.length} Questions",
                            ),
                            _buildMetaBadge(
                              icon: AppIcons.info(
                                size: 16,
                                color: AppColors.correctText,
                              ),
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
                        color: AppColors.skyBlue.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.5.w),
                          decoration: BoxDecoration(
                            color: AppColors.actionBlue.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: AppIcons.calendar(
                            color: AppColors.skyBlue,
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
                                  color: AppColors.skyBlue,
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

                  // 9 Detailed Rules
                  InstructionRuleCard(
                    icon: AppIcons.warning(size: 20, color: AppColors.alertRed),
                    title: "1. Pas de retour en arrière",
                    description:
                        "Une fois qu'une question est validée et que vous passez à la suivante, il est impossible de revenir en arrière.",
                  ),
                  SizedBox(height: 1.5.h),

                  InstructionRuleCard(
                    icon: AppIcons.timer(size: 20, color: AppColors.skyBlue),
                    title: "2. Banque de Temps Bonus",
                    description:
                        "Le temps inutilisé sur une question QCM est automatiquement crédité à votre Banque de Bonus pour les questions suivantes.",
                  ),
                  SizedBox(height: 1.5.h),

                  InstructionRuleCard(
                    icon: AppIcons.lock(size: 20, color: AppColors.unauthorizedText),
                    title: "3. Protection Anti-Capture (FLAG_SECURE)",
                    description:
                        "Le système bloque nativement les captures d'écran et les enregistrements vidéo durant toute la durée de l'épreuve.",
                  ),
                  SizedBox(height: 1.5.h),

                  InstructionRuleCard(
                    icon: AppIcons.alert02(size: 20, color: AppColors.warningAmber),
                    title: "4. Détection de Changement d'App (3 Max)",
                    description:
                        "Quitter l'application ou passer en arrière-plan enregistre un avertissement. À 3 sorties, le test est automatiquement soumis.",
                  ),
                  SizedBox(height: 1.5.h),

                  InstructionRuleCard(
                    icon: AppIcons.cancel(size: 20, color: AppColors.errorText),
                    title: "5. Copier-Coller Désactivé",
                    description:
                        "La sélection de texte, la copie et le collage depuis des sources externes sont strictement bloqués.",
                  ),
                  SizedBox(height: 1.5.h),

                  InstructionRuleCard(
                    icon: AppIcons.star(size: 20, color: AppColors.correctText),
                    title: "6. Détection Automatique d'IA",
                    description:
                        "Les réponses rédigées ou snippets de code générés par IA seront disqualifiés lors de la correction backend.",
                  ),
                  SizedBox(height: 1.5.h),

                  InstructionRuleCard(
                    icon: AppIcons.forms(size: 20, color: AppColors.skyBlue),
                    title: "7. Évaluation Hybride",
                    description:
                        "L'épreuve combine des QCM auto-corrigés (25 pts/QCM) et des questions de code Dart / rédaction.",
                  ),
                  SizedBox(height: 1.5.h),

                  InstructionRuleCard(
                    icon: AppIcons.info(size: 20, color: AppColors.skyBlue),
                    title: "8. Tentative Unique par Jour",
                    description:
                        "Une seule soumission est autorisée par participant par session d'examen quotidienne.",
                  ),
                  SizedBox(height: 1.5.h),

                  InstructionRuleCard(
                    icon: AppIcons.time(size: 20, color: AppColors.skyBlue),
                    title: "9. Soumission Automatique à zéro",
                    description:
                        "Dès que le chrono global ou de dernière question atteint zéro, vos réponses sont immédiatement transmises.",
                  ),
                  SizedBox(height: 2.5.h),
                ],
              ),
            ),

            // Bottom Start Button Container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<TestBloc>().add(const StartQuizEvent());

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
                label: Text(
                  "Commencer l'évaluation",
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
}
