import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/test_quiz_entity.dart';

class QuizHeader extends StatelessWidget {
  final TestQuizEntity quiz;
  final int currentQuestionIndex;
  final String formattedTime;

  const QuizHeader({
    super.key,
    required this.quiz,
    required this.currentQuestionIndex,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    final totalQuestions = quiz.questions.length;
    final progress = (currentQuestionIndex + 1) / totalQuestions;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        spacing: 1.5.h,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Question ${currentQuestionIndex + 1} / $totalQuestions",
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: .bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: AppColors.firebaseOrange.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular8,
                  border: Border.all(color: AppColors.firebaseOrange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  spacing: 1.5.w,
                  children: [
                    AppIcons.timer(size: 16, color: AppColors.firebaseOrange),
                    Text(
                      formattedTime,
                      style: AppTextStyles.badge.copyWith(
                        color: AppColors.firebaseOrange,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: AppRadius.circular6,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.ultraDark,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.actionBlue),
            ),
          ),
        ],
      ),
    );
  }
}
