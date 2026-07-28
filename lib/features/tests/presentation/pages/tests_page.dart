import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/question_item_entity.dart';
import 'test_taking_page.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  static const List<QuestionItemEntity> _mockQuestions = [
    QuestionItemEntity(
      id: 'q1',
      title: 'Quelle est la différence fondamentale entre StatelessWidget et StatefulWidget dans Flutter ?',
      type: 'choice',
      level: 1,
      modules: [1],
      points: 10,
      timingSeconds: 300,
      options: [
        'StatelessWidget est mutable alors que StatefulWidget est immuable.',
        'StatelessWidget ne possède pas d\'état interne mutable, alors que StatefulWidget conserve un State persistant.',
        'StatefulWidget est uniquement utilisé pour le rendu de texte.',
        'StatelessWidget est exécuté sur le GPU direct.',
      ],
      correctAnswers: [1],
      explanation: 'StatelessWidget est idéal pour les UI statiques car sa méthode build est pure par rapport à ses propriétés.',
    ),
    QuestionItemEntity(
      id: 'q2',
      title: 'Dans BLoC Pattern, comment un Widget écoute-t-il les changements d\'état pour reconstruire l\'UI ?',
      type: 'choice',
      level: 2,
      modules: [2],
      points: 15,
      timingSeconds: 300,
      options: [
        'En utilisant setState() à chaque mise à jour.',
        'Grâce au widget BlocBuilder ou BlocConsumer.',
        'En déclenchant la méthode dispatch() globale.',
        'En utilisant un Timer.periodic.',
      ],
      correctAnswers: [1],
      explanation: 'BlocBuilder s\'abonne aux flux de state émis par le BLoC pour rebuild son sous-arbre de widgets.',
    ),
    QuestionItemEntity(
      id: 'q3',
      title: 'Quelle méthode de Firestore permet de lire un document en temps réel avec un flux Stream ?',
      type: 'choice',
      level: 3,
      modules: [3],
      points: 20,
      timingSeconds: 300,
      options: [
        'doc().get()',
        'doc().snapshots()',
        'doc().fetch()',
        'doc().observe()',
      ],
      correctAnswers: [1],
      explanation: 'snapshots() renvoie un Stream<DocumentSnapshot> qui émet une nouvelle valeur dès que les données changent.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tests & Quiz"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(4.w),
        itemCount: _mockQuestions.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final q = _mockQuestions[index];
          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular16,
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
                        borderRadius: AppRadius.circular8,
                      ),
                      child: Text(
                        "Niveau ${q.level} • ${q.points} pts",
                        style: AppTextStyles.badge,
                      ),
                    ),
                    Row(
                      children: [
                        AppIcons.timer(size: AppSizes.iconSm, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          "5 min",
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  q.title,
                  style: AppTextStyles.titleMedium,
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
                      padding: EdgeInsets.symmetric(vertical: 1.4.h),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.circular10,
                      ),
                    ),
                    icon: AppIcons.tests(size: AppSizes.iconSm, color: Colors.white),
                    label: Text(
                      "Commencer le Quiz",
                      style: AppTextStyles.buttonSmall,
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
