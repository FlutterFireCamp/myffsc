import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/test_quiz_entity.dart';
import '../../domain/entities/user_question_correction.dart';
import 'test_correction_bottom_sheet.dart';

class TestAlreadySubmittedCard extends StatelessWidget {
  final TestQuizEntity quiz;
  final int score;
  final int totalPossibleScore;
  final Map<int, dynamic> userAnswersMap;
  final String status;

  const TestAlreadySubmittedCard({
    super.key,
    required this.quiz,
    required this.score,
    required this.totalPossibleScore,
    required this.userAnswersMap,
    this.status = "Corrigé",
  });

  void _handleViewDetails(BuildContext context) {
    final List<UserQuestionCorrection> corrections = [];
    for (int i = 0; i < quiz.questions.length; i++) {
      final q = quiz.questions[i];
      final ans = userAnswersMap[i];
      bool isCorrect = false;
      if (q.type == 'choice' && q.correctAnswers != null && ans != null) {
        final intAns = ans is int ? ans : int.tryParse(ans.toString());
        if (intAns != null) {
          isCorrect =
              q.correctAnswers!.contains(intAns) ||
              q.correctAnswers!.contains(intAns - 1) ||
              q.correctAnswers!.contains(intAns + 1);
        }
      }
      corrections.add(
        UserQuestionCorrection(
          index: i,
          questionId: q.id,
          title: q.title,
          statement: q.statement,
          type: q.type,
          studentAnswer: ans != null ? ans.toString() : "-1",
          earnedScore: isCorrect ? q.points : 0,
          maxScore: q.points > 0 ? q.points : 25,
          options: q.options,
          correctAnswers: q.correctAnswers,
          explanation: q.explanation,
        ),
      );
    }

    TestCorrectionBottomSheet.show(
      context,
      quizTitle: quiz.title,
      dateFormatted: DateTimeHelper.formatYmd(DateTime.now()),
      totalScore: score,
      totalPossibleScore: totalPossibleScore,
      status: status,
      questions: corrections,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(5.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular20,
        border: .all(color: AppColors.programTestBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // Top Row: Status Badge (Left) & Total points / Date
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: AppColors.programTestBadgeBg,
                  borderRadius: AppRadius.circular8,
                ),
                child: Row(
                  mainAxisSize: .min,
                  spacing: 1.w,
                  children: [
                    AppIcons.check(color: AppColors.programTestBadge, size: 16),
                    Text(
                      "DÉJÀ SOUMIS",
                      style: AppTextStyles.badgeSmall.copyWith(
                        color: AppColors.programTestBadge,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Épreuve du jour",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: .w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.8.h),

          // Title
          Text(
            quiz.title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: .bold,
            ),
          ),
          SizedBox(height: 0.8.h),

          // Subtitle / Info
          Text(
            "Votre évaluation a été enregistrée avec succès. Vous pouvez consulter les explications et détails de correction ci-dessous.",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),

          // Divider Line
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            child: const Divider(
              color: AppColors.borderSubtle,
              height: 1,
              thickness: 0.8,
            ),
          ),

          // Bottom Row: Score (Left) & Voir détails TextButton (Right)
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "$score / $totalPossibleScore pts",
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.skyBlue,
                  fontWeight: .bold,
                ),
              ),
              TextButton(
                onPressed: () => _handleViewDetails(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: .shrinkWrap,
                ),
                child: Text(
                  "Voir détails",
                  style: AppTextStyles.buttonSmall.copyWith(
                    color: AppColors.skyBlue,
                    fontWeight: .bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
