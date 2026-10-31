import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/bloc.dart';
import '../widgets/test_already_submitted_card.dart';
import '../widgets/test_quiz_card.dart';
import '../widgets/tests_shimmer.dart';

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
        title: Text("Évaluation", style: AppTextStyles.h3),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: "Actualiser",
            icon: AppIcons.refresh03(color: AppColors.skyBlue, size: 20),
            onPressed: () {
              context.read<TestBloc>().add(FetchTodayTestEvent(userId: userId));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<TestBloc, TestState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
          builder: (context, state) {
            // State 1: Shimmer Loading Skeleton
            if (state.isLoading) {
              return const TestsShimmer();
            }

            final quiz = state.activeQuiz;

            // State 2: Aucune évaluation programmée / disponible
            if (quiz == null) {
              return Center(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: AppEmptyState(
                    title: "Aucune évaluation disponible",
                    message:
                        "L'épreuve programmée s'affichera automatiquement ici dès le lancement de la session.",
                    icon: AppIcons.tests(
                      color: AppColors.skyBlue,
                      size: AppSizes.iconXl,
                    ),
                    accentColor: AppColors.skyBlue,
                  ),
                ),
              );
            }

            // State 3: Déjà soumis aujourd'hui (Already Submitted State)
            if (state.isSubmittedToday) {
              final prevData = state.previousSubmission;

              // Extract or reconstruct user answers map
              final Map<int, dynamic> userAnswers =
                  Map<int, dynamic>.from(state.userAnswersMap);
              if (userAnswers.isEmpty && prevData?['answers'] != null) {
                final prevAnswers = prevData!['answers'];
                if (prevAnswers is List) {
                  for (int i = 0; i < prevAnswers.length; i++) {
                    final item = prevAnswers[i];
                    if (item is Map) {
                      userAnswers[i] = item['studentAnswer'] ??
                          item['answer'] ??
                          item['userAnswer'];
                    } else {
                      userAnswers[i] = item;
                    }
                  }
                } else if (prevAnswers is Map) {
                  int i = 0;
                  for (final val in prevAnswers.values) {
                    if (val is Map) {
                      userAnswers[i] = val['studentAnswer'] ??
                          val['answer'] ??
                          val['userAnswer'];
                    } else {
                      userAnswers[i] = val;
                    }
                    i++;
                  }
                }
              }

              // Extract score safely
              int score = (prevData?['score'] as num?)?.toInt() ??
                  (prevData?['totalScore'] as num?)?.toInt() ??
                  (prevData?['points'] as num?)?.toInt() ??
                  state.qcmScore;

              if (score == 0 && prevData?['answers'] != null) {
                final prevAnswers = prevData!['answers'];
                if (prevAnswers is List) {
                  for (final item in prevAnswers) {
                    if (item is Map) {
                      score += (item['score'] as num?)?.toInt() ??
                          (item['earnedScore'] as num?)?.toInt() ??
                          (item['isCorrect'] == true
                              ? ((item['points'] as num?)?.toInt() ?? 25)
                              : 0);
                    }
                  }
                }
              }

              // Extract total possible score (never 500)
              final rawTotalPossible =
                  (prevData?['totalPossibleScore'] as num?)?.toInt() ??
                      (prevData?['totalPoints'] as num?)?.toInt();
              final totalPossible = (rawTotalPossible != null &&
                      rawTotalPossible > 0 &&
                      rawTotalPossible != 500)
                  ? rawTotalPossible
                  : quiz.calculatedTotalPoints;

              final status =
                  prevData?['status']?.toString() ?? "Corrigé";

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: TestAlreadySubmittedCard(
                  quiz: quiz,
                  score: score,
                  totalPossibleScore: totalPossible,
                  userAnswersMap: userAnswers,
                  status: status,
                ),
              );
            }

            // State 4: Test disponible à passer (Active Test State)
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: TestQuizCard(quiz: quiz),
            );
          },
        ),
      ),
    );
  }
}
