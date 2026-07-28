import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/question_item_entity.dart';
import 'test_taking_page.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  List<QuestionItemEntity> _getMockQuestions() {
    return const [
      QuestionItemEntity(
        id: 'q1',
        title: 'En Dart, quel mot-clé permet de déclarer une variable immuable évaluée à la compilation ?',
        type: 'choice',
        level: 1,
        modules: [1],
        points: 10,
        options: ['final', 'const', 'var', 'static'],
        correctAnswers: [1],
        explanation: 'Le mot-clé const crée des constantes au moment de la compilation.',
      ),
      QuestionItemEntity(
        id: 'q2',
        title: 'Quel widget réagit aux changements d\'état de BLoC pour reconstruire l\'UI ?',
        type: 'choice',
        level: 3,
        modules: [3],
        points: 10,
        options: ['BlocListener', 'BlocBuilder', 'BlocObserver', 'RepositoryProvider'],
        correctAnswers: [1],
        explanation: 'BlocBuilder reconstruit son widget enfant chaque fois qu\'un nouvel état est émis.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final questions = _getMockQuestions();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tests & Évaluations 🧪"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        itemCount: questions.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final q = questions[index];
          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                      decoration: BoxDecoration(
                        color: AppColors.actionBlue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Niveau ${q.level} • ${q.points} pts",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.skyBlue,
                        ),
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(AppIcons.timer, size: 14, color: AppColors.textMuted),
                        SizedBox(width: 4),
                        Text(
                          "15 min",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  q.title,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TestTakingPage(question: q),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.actionBlue,
                      padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(AppIcons.tests, size: 18, color: Colors.white),
                    label: Text(
                      "Commencer le Quiz",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
