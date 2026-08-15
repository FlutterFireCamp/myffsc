import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../tests/data/services/test_firestore_service.dart';
import '../../../tests/domain/entities/question_item_entity.dart';
import '../../../tests/domain/entities/test_quiz_entity.dart';
import '../../../tests/presentation/widgets/test_correction_bottom_sheet.dart';

class ProfileTestHistorySection extends StatelessWidget {
  final String userId;

  const ProfileTestHistorySection({super.key, required this.userId});

  Future<void> _handleViewDetails(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final quizId = data['quizId'] as String? ?? 'ffsc_exam_2026';
    final quizTitle = data['quizTitle'] as String? ?? 'Évaluation FFSC';
    final score = (data['score'] as num?)?.toInt() ?? 0;
    final rawAnswers = data['answers'] as Map<String, dynamic>? ?? {};

    // Parse answers back to Map<int, dynamic>
    final Map<int, dynamic> userAnswers = {};
    rawAnswers.forEach((key, value) {
      final intKey = int.tryParse(key);
      if (intKey != null) {
        userAnswers[intKey] = value;
      }
    });

    // Try fetching official quiz from Firestore /tests
    TestQuizEntity? quiz = await TestFirestoreService().fetchTestById(quizId);

    // Fallback: build a mock quiz structure matching answers if not found in /tests
    if (quiz == null) {
      final List<QuestionItemEntity> fallbackQuestions = [];
      userAnswers.forEach((idx, val) {
        fallbackQuestions.add(
          QuestionItemEntity(
            id: "q_$idx",
            title: "Question ${idx + 1}",
            type: val is int ? 'choice' : 'text',
            level: 1,
            modules: const [1],
            points: 25,
            timingSeconds: 60,
            options: val is int
                ? const ["Option A", "Option B", "Option C", "Option D"]
                : null,
            correctAnswers: val is int ? [val] : null,
            explanation: "Explication détaillée de la réponse.",
          ),
        );
      });

      quiz = TestQuizEntity(
        id: quizId,
        title: quizTitle,
        description: "Évaluation enregistrée",
        totalDurationMinutes: 10,
        totalPoints: (data['totalPossibleScore'] as num?)?.toInt() ?? 100,
        questions: fallbackQuestions,
        status: 'active',
      );
    }

    if (context.mounted) {
      TestCorrectionBottomSheet.show(
        context,
        quiz: quiz,
        userAnswers: userAnswers,
        totalScore: score,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Historique des Évaluations",
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('tests')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const AppShimmer(child: AppCardShimmer()),
              );
            }

            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Center(
                  child: Column(
                    children: [
                      AppIcons.tests(color: AppColors.textMuted, size: 32),
                      SizedBox(height: 1.h),
                      Text(
                        "Aucun historique d'évaluation disponible",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
              itemBuilder: (context, index) {
                final data = docs[index].data();
                final quizTitle =
                    data['quizTitle'] as String? ?? "Évaluation FFSC";
                final score = (data['score'] as num?)?.toInt() ?? 0;
                final totalPossible =
                    (data['totalPossibleScore'] as num?)?.toInt() ?? 100;
                final dateStr = data['date'] as String? ?? '';

                final rawStatus = data['status'] as String?;
                final isGraded = data['isGraded'] as bool? ?? (rawStatus == 'CORRIGÉ');
                final isPending = rawStatus == 'EN ATTENTE' || !isGraded;

                final badgeLabel = isPending ? "EN ATTENTE" : "CORRIGÉ";
                final badgeColor = isPending ? AppColors.skyBlue : AppColors.correctText;
                final badgeBg = isPending
                    ? AppColors.actionBlue.withValues(alpha: 0.15)
                    : AppColors.successGreen.withValues(alpha: 0.15);
                final badgeBorder = isPending
                    ? AppColors.actionBlue.withValues(alpha: 0.3)
                    : AppColors.successGreen.withValues(alpha: 0.3);

                return Container(
                  padding: EdgeInsets.all(4.5.w),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: AppRadius.circular16,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Title + Date (Left) & CORRIGÉ / EN ATTENTE Badge (Right)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quizTitle,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 0.4.h),
                              Text(
                                "Date : $dateStr",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 0.6.h,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: AppRadius.circular20,
                              border: Border.all(color: badgeBorder),
                            ),
                            child: Text(
                              badgeLabel,
                              style: AppTextStyles.badge.copyWith(
                                color: badgeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 9.sp,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
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

                      // Bottom Row: Score (Left) & Voir détails Button (Right)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$score / $totalPossible pts",
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.skyBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () => _handleViewDetails(context, data),
                            borderRadius: AppRadius.circular12,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.skyBlue.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: AppRadius.circular12,
                                border: Border.all(
                                  color: AppColors.skyBlue.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                "Voir détails",
                                style: AppTextStyles.buttonSmall.copyWith(
                                  color: AppColors.skyBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
