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
    final availableQuizzes = <TestQuizEntity>[MockTestsData.sampleDartQuiz];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Évaluations", style: AppTextStyles.h3),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
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
      backgroundColor: AppColors.firebaseYellow.withValues(alpha: 0.15),
      border: Border.all(
        color: AppColors.firebaseYellow.withValues(alpha: 0.3),
        width: 1.5,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
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
            child: AppIcons.tests(size: 36, color: AppColors.firebaseYellow),
          ),
          SizedBox(height: 2.5.h),
          Text(
            "Pas d'évaluation disponible",
            textAlign: TextAlign.center,
            style: AppTextStyles.h3,
          ),
          SizedBox(height: 1.2.h),
          Text(
            "L'évaluation s'affichera automatiquement ici dès son ouverture par les organisateurs.",
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
