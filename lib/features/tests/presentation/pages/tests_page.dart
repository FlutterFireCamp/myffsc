import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/bloc.dart';
import '../../domain/entities/user_question_correction.dart';
import '../widgets/test_correction_bottom_sheet.dart';
import '../widgets/tests_shimmer.dart';
import '../widgets/test_quiz_card.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key});

  @override
  State<TestsPage> createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  @override
  void initState() {
    super.initState();
    _fetchTodayTest();
  }

  void _fetchTodayTest() {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is AuthenticatedState ? authState.user.id : '';
    context.read<TestBloc>().add(FetchTodayTestEvent(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userId = authState is AuthenticatedState ? authState.user.id : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Évaluations", style: AppTextStyles.h3),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: "Actualiser",
            icon: AppIcons.refresh03(color: AppColors.actionBlue, size: 20),
            onPressed: () {
              context.read<TestBloc>().add(FetchTodayTestEvent(userId: userId));
            },
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<TestBloc, TestState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const TestsShimmer();
            }

            final quiz = state.activeQuiz;

            // State 3: Aucun test disponible
            if (quiz == null) {
              return RefreshIndicator(
                color: AppColors.skyBlue,
                onRefresh: () async => _fetchTodayTest(),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  children: [
                    SizedBox(height: 10.h),
                    AppEmptyState(
                      title: "Aucune évaluation disponible",
                      message:
                          "Les épreuves programmées s'afficheront automatiquement ici dès le lancement de la session.",
                      icon: AppIcons.tests(color: AppColors.skyBlue, size: AppSizes.iconXl),
                      accentColor: AppColors.skyBlue,
                      actionLabel: "Actualiser",
                      onAction: _fetchTodayTest,
                    ),
                  ],
                ),
              );
            }

            // State 2: Déjà soumis aujourd'hui
            if (state.isSubmittedToday) {
              final score = state.previousSubmission?['score'] as int? ?? state.qcmScore;
              final totalPossible =
                  state.previousSubmission?['totalPossibleScore'] as int? ?? state.totalPossibleScore;

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                children: [
                  Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: AppRadius.circular20,
                      border: Border.all(
                        color: AppColors.correctBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 0.6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.correctContainer,
                                borderRadius: AppRadius.circular8,
                              ),
                              child: Row(
                                spacing: 1.w,
                                children: [
                                  AppIcons.check(color: AppColors.correctText, size: 16),
                                  Text(
                                    "DÉJÀ SOUMIS",
                                    style: AppTextStyles.badgeSmall.copyWith(
                                      color: AppColors.correctText,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "$score / $totalPossible Pts",
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.skyBlue,
                                fontWeight: .bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          quiz.title,
                          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 0.8.h),
                        Text(
                          "Votre évaluation a été enregistrée avec succès. Vous pouvez consulter les explications et détails de correction ci-dessous.",
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                        SizedBox(height: 2.5.h),

                        ElevatedButton.icon(
                          onPressed: () {
                            final List<UserQuestionCorrection> corrections = [];
                            final userAnsMap = state.userAnswersMap;
                            for (int i = 0; i < quiz.questions.length; i++) {
                              final q = quiz.questions[i];
                              final ans = userAnsMap[i];
                              bool isCorrect = false;
                              if (q.type == 'choice' && q.correctAnswers != null && ans != null) {
                                final intAns = ans is int ? ans : int.tryParse(ans.toString());
                                if (intAns != null) {
                                  isCorrect = q.correctAnswers!.contains(intAns) ||
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
                              totalPossibleScore: totalPossible,
                              status: state.previousSubmission?['status']?.toString() ?? "Corrigé",
                              questions: corrections,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.actionBlue,
                            padding: EdgeInsets.symmetric(vertical: 1.6.h),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.circular14,
                            ),
                          ),
                          icon: AppIcons.info(color: Colors.white, size: 18),
                          label: Text(
                            "Voir mes résultats & la correction",
                            style: AppTextStyles.button.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            // State 1: Test Disponible
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              children: [
                TestQuizCard(quiz: quiz),
              ],
            );
          },
        ),
      ),
    );
  }
}
