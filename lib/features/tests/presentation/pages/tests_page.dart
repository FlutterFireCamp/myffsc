import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../data/datasources/mock_tests_data.dart';
import '../../domain/entities/test_quiz_entity.dart';
import 'test_instructions_page.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final availableQuizzes = <TestQuizEntity>[
      MockTestsData.sampleDartQuiz,
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Tests & Évaluations",
          style: AppTextStyles.h3,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
          Text(
            "Examens Disponibles",
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            "Sélectionnez une épreuve pour consulter les consignes et démarrer.",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 2.5.h),

          if (availableQuizzes.isEmpty)
            _buildEmptyState()
          else
            ...availableQuizzes.map((quiz) => _buildQuizCard(context, quiz)),
        ],
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, TestQuizEntity quiz) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.5.h),
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
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: AppColors.correctContainer,
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
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
            ),
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
              color: AppColors.ultraDark,
              borderRadius: AppRadius.circular8,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                AppIcons.calendar(size: 16, color: AppColors.firebaseOrange),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    quiz.localAvailabilityRangeText,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestInstructionsPage(quiz: quiz),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                backgroundColor: AppColors.actionBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.circular12,
                ),
                elevation: 0,
              ),
              icon: AppIcons.arrowRight(color: Colors.white, size: 18),
              label: Text(
                "Consulter & Débuter",
                style: AppTextStyles.button.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.firebaseYellow.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.firebaseYellow.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: AppIcons.tests(
              size: 36,
              color: AppColors.firebaseYellow,
            ),
          ),
          SizedBox(height: 2.5.h),
          Text(
            "Aucun Quiz Actif",
            textAlign: TextAlign.center,
            style: AppTextStyles.h3,
          ),
          SizedBox(height: 1.2.h),
          Text(
            "Le quiz s'affichera automatiquement ici dès l'ouverture de la session par les administrateurs.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
