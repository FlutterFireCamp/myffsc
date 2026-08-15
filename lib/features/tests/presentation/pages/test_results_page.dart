import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/test_quiz_entity.dart';
import '../widgets/test_correction_bottom_sheet.dart';

class TestResultsPage extends StatelessWidget {
  final TestQuizEntity quiz;
  final Map<int, dynamic> userAnswers;
  final int qcmScore;
  final int totalPossibleScore;
  final int timeSpentSeconds;
  final int tabSwitchCount;

  const TestResultsPage({
    super.key,
    required this.quiz,
    required this.userAnswers,
    required this.qcmScore,
    required this.totalPossibleScore,
    required this.timeSpentSeconds,
    required this.tabSwitchCount,
  });

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "${mins}m ${secs}s";
  }

  @override
  Widget build(BuildContext context) {
    final percentage = totalPossibleScore > 0
        ? ((qcmScore / totalPossibleScore) * 100).round()
        : 0;

    final isPassed = percentage >= 50;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Résultats de l'Examen"),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 2.h),

                    // Result Header Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: AppRadius.circular20,
                        border: Border.all(
                          color: isPassed
                              ? AppColors.correctBorder
                              : AppColors.actionBlue.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: isPassed
                                  ? AppColors.correctContainer
                                  : AppColors.actionBlue.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: AppIcons.trophy(
                              color: isPassed
                                  ? AppColors.correctText
                                  : AppColors.skyBlue,
                              size: 40,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            isPassed ? "Félicitations ! 🎉" : "Examen Soumis !",
                            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 0.8.h),
                          Text(
                            quiz.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                          SizedBox(height: 2.5.h),

                          // Score Pill
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h),
                            decoration: BoxDecoration(
                              color: AppColors.ultraDark,
                              borderRadius: AppRadius.circular14,
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Score Auto QCM",
                                  style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                                ),
                                SizedBox(height: 0.4.h),
                                Text(
                                  "$qcmScore / $totalPossibleScore Pts",
                                  style: AppTextStyles.h1.copyWith(
                                    color: AppColors.skyBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "$percentage% de réussite",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isPassed ? AppColors.correctText : AppColors.textSecondary,
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

                    // Stats Grid
                    Row(
                      spacing: 3.w,
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            icon: AppIcons.time(color: AppColors.skyBlue, size: 20),
                            label: "Temps passé",
                            value: _formatDuration(timeSpentSeconds),
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            icon: AppIcons.alert02(
                              color: tabSwitchCount == 0
                                  ? AppColors.correctText
                                  : AppColors.warningAmber,
                              size: 20,
                            ),
                            label: "Sorties d'app",
                            value: "$tabSwitchCount / 3",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      TestCorrectionBottomSheet.show(
                        context,
                        quiz: quiz,
                        userAnswers: userAnswers,
                        totalScore: qcmScore,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardHover,
                      foregroundColor: AppColors.skyBlue,
                      padding: EdgeInsets.symmetric(vertical: 1.8.h),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.circular14,
                        side: BorderSide(color: AppColors.skyBlue, width: 1.2),
                      ),
                      elevation: 0,
                    ),
                    icon: AppIcons.info(color: AppColors.skyBlue, size: 20),
                    label: Text(
                      "Voir la correction détaillée",
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.skyBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Back to hub
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.actionBlue,
                      padding: EdgeInsets.symmetric(vertical: 1.8.h),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.circular14,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Retour au hub d'évaluations",
                      style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required Widget icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular14,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          SizedBox(height: 1.h),
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
          SizedBox(height: 0.3.h),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
