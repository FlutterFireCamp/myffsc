import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/test_quiz_entity.dart';

class TestCorrectionBottomSheet extends StatelessWidget {
  final TestQuizEntity quiz;
  final Map<int, dynamic> userAnswers;
  final int totalScore;

  const TestCorrectionBottomSheet({
    super.key,
    required this.quiz,
    required this.userAnswers,
    required this.totalScore,
  });

  static void show(
    BuildContext context, {
    required TestQuizEntity quiz,
    required Map<int, dynamic> userAnswers,
    required int totalScore,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TestCorrectionBottomSheet(
        quiz: quiz,
        userAnswers: userAnswers,
        totalScore: totalScore,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 85.h),
      decoration: const BoxDecoration(
        color: AppColors.modalBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle indicator
          Center(
            child: Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Header Title & Score Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Correction Détaillée",
                    style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 0.4.h),
                  Text(
                    quiz.title,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.8.h),
                decoration: BoxDecoration(
                  color: AppColors.actionBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular12,
                  border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.4)),
                ),
                child: Text(
                  "$totalScore Pts",
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.skyBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          const Divider(color: AppColors.borderSubtle),
          SizedBox(height: 1.h),

          // Questions List
          Expanded(
            child: ListView.separated(
              itemCount: quiz.questions.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final question = quiz.questions[index];
                final userAnswer = userAnswers[index];
                final isChoice = question.type == 'choice';

                bool isCorrect = false;
                if (isChoice && question.correctAnswers != null && userAnswer != null) {
                  isCorrect = question.correctAnswers!.contains(userAnswer);
                }

                return Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: AppRadius.circular14,
                    border: Border.all(
                      color: isChoice
                          ? (isCorrect
                              ? AppColors.correctBorder
                              : AppColors.incorrectBorder)
                          : AppColors.borderSubtle,
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Question # & Status Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Question ${index + 1} (${question.points} Pts)",
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isChoice)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w,
                                vertical: 0.4.h,
                              ),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? AppColors.correctContainer
                                    : AppColors.incorrectContainer,
                                borderRadius: AppRadius.circular8,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                    size: 14,
                                    color: isCorrect
                                        ? AppColors.correctText
                                        : AppColors.errorText,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    isCorrect ? "Correct (+25 pts)" : "Incorrect (0 pt)",
                                    style: AppTextStyles.caption.copyWith(
                                      color: isCorrect
                                          ? AppColors.correctText
                                          : AppColors.errorText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w,
                                vertical: 0.4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.actionBlue.withValues(alpha: 0.15),
                                borderRadius: AppRadius.circular8,
                              ),
                              child: Text(
                                "En attente de correction ⏳",
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.skyBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 1.h),

                      // Question Title
                      Text(
                        question.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.5.h),

                      // Options & Answers List
                      if (isChoice && question.options != null) ...[
                        Column(
                          children: List.generate(question.options!.length, (optIdx) {
                            final isOptionCorrect =
                                question.correctAnswers?.contains(optIdx) ?? false;
                            final isUserSelected = userAnswer == optIdx;

                            Color optBg = AppColors.card;
                            Color optBorder = AppColors.borderSubtle;
                            Widget badgeWidget = const SizedBox.shrink();

                            if (isOptionCorrect && isUserSelected) {
                              optBg = AppColors.correctContainer;
                              optBorder = AppColors.correctBorder;
                              badgeWidget = Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppIcons.check(color: AppColors.correctText, size: 14),
                                  SizedBox(width: 1.w),
                                  Text(
                                    "✓ Correct (Votre réponse)",
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.correctText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8.5.sp,
                                    ),
                                  ),
                                ],
                              );
                            } else if (isOptionCorrect && !isUserSelected) {
                              optBg = AppColors.correctContainer.withValues(alpha: 0.5);
                              optBorder = AppColors.correctBorder.withValues(alpha: 0.6);
                              badgeWidget = Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppIcons.check(color: AppColors.correctText, size: 14),
                                  SizedBox(width: 1.w),
                                  Text(
                                    "✓ Bonne réponse",
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.correctText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8.5.sp,
                                    ),
                                  ),
                                ],
                              );
                            } else if (isUserSelected && !isOptionCorrect) {
                              optBg = AppColors.incorrectContainer;
                              optBorder = AppColors.incorrectBorder;
                              badgeWidget = Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppIcons.cancel(color: AppColors.errorText, size: 14),
                                  SizedBox(width: 1.w),
                                  Text(
                                    "✕ Votre choix (Incorrect)",
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.errorText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8.5.sp,
                                    ),
                                  ),
                                ],
                              );
                            }

                            final letters = ['A', 'B', 'C', 'D', 'E', 'F'];
                            final letter = optIdx < letters.length ? letters[optIdx] : '${optIdx + 1}';

                            return Container(
                              margin: EdgeInsets.only(bottom: 0.8.h),
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
                              decoration: BoxDecoration(
                                color: optBg,
                                borderRadius: AppRadius.circular10,
                                border: Border.all(color: optBorder),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "$letter. ",
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isOptionCorrect
                                          ? AppColors.correctText
                                          : (isUserSelected
                                              ? AppColors.errorText
                                              : AppColors.textSecondary),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      question.options![optIdx],
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: isUserSelected || isOptionCorrect
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  badgeWidget,
                                ],
                              ),
                            );
                          }),
                        ),
                      ] else ...[
                        Text(
                          "Votre réponse :",
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.4.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppColors.ultraDark,
                            borderRadius: AppRadius.circular10,
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Text(
                            userAnswer != null ? userAnswer.toString() : "Aucune réponse fournie",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: userAnswer != null
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                              fontStyle: userAnswer == null ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 1.5.h),

                      // Explanation Text
                      if (question.explanation != null && question.explanation!.isNotEmpty) ...[
                        Text(
                          "Explication & Solution :",
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.skyBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 0.4.h),
                        Text(
                          question.explanation!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),

          // Close Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionBlue,
                padding: EdgeInsets.symmetric(vertical: 1.6.h),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.circular14,
                ),
              ),
              child: Text(
                "Fermer",
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
