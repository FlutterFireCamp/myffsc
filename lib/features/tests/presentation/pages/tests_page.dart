import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../data/datasources/mock_tests_data.dart';
import '../../domain/entities/test_quiz_entity.dart';
import '../widgets/test_quiz_card.dart';

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
            ...availableQuizzes.map((quiz) => TestQuizCard(quiz: quiz)),
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
