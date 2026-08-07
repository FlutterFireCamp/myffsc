import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/test_quiz_entity.dart';
import '../pages/test_instructions_page.dart';

class TestQuizCard extends StatelessWidget {
  final TestQuizEntity quiz;

  const TestQuizCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.5.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        borderRadius: AppRadius.circular16,
        color: AppColors.firebaseYellow.withValues(alpha: 0.15),
        border: Border.all(
          color: AppColors.firebaseYellow.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.circular8,
                  border: Border.all(color: AppColors.correctBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.correctText,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      "DISPONIBLE",
                      style: AppTextStyles.badgeSmall.copyWith(
                        color: AppColors.correctText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                "${quiz.totalPoints} Pts",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.firebaseYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            quiz.title,
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 1.h),
          Text(
            quiz.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),

          // Time Window Local Info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppColors.firebaseYellow.withValues(alpha: 0.3),
              borderRadius: AppRadius.circular8,
              border: Border.all(color: AppColors.firebaseYellow),
            ),
            child: Row(
              children: [
                AppIcons.calendar(size: 16, color: AppColors.firebaseYellow),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    quiz.localAvailabilityRangeText,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.firebaseYellow,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.5.h),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => TestInstructionsPage(quiz: quiz),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                backgroundColor: AppColors.firebaseYellow,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.circular12,
                ),
                elevation: 0,
              ),
              label: Text(
                "Consulter & Débuter",
                style: AppTextStyles.button.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
