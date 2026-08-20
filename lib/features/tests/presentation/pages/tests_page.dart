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
            // State 1: Chargement
            if (state.isLoading) {
              return const TestsShimmer();
            }

            final quiz = state.activeQuiz;

            // State 2: Aucun test disponible (Empty State)
            if (quiz == null) {
              return RefreshIndicator(
                color: AppColors.skyBlue,
                onRefresh: () async => _fetchTodayTest(),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                  children: [
                    AppEmptyState(
                      title: "Aucune évaluation disponible",
                      message:
                          "Les épreuves programmées s'afficheront automatiquement ici dès le lancement de la session.",
                      icon: AppIcons.tests(
                        color: AppColors.skyBlue,
                        size: AppSizes.iconXl,
                      ),
                      accentColor: AppColors.skyBlue,
                      actionLabel: "Actualiser",
                      onAction: _fetchTodayTest,
                    ),
                  ],
                ),
              );
            }

            // State 3: Déjà soumis aujourd'hui (Already Submitted State)
            if (state.isSubmittedToday) {
              final score =
                  state.previousSubmission?['score'] as int? ?? state.qcmScore;
              final totalPossible =
                  state.previousSubmission?['totalPossibleScore'] as int? ??
                  state.totalPossibleScore;
              final status =
                  state.previousSubmission?['status']?.toString() ?? "Corrigé";

              return RefreshIndicator(
                color: AppColors.skyBlue,
                onRefresh: () async => _fetchTodayTest(),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  children: [
                    TestAlreadySubmittedCard(
                      quiz: quiz,
                      score: score,
                      totalPossibleScore: totalPossible,
                      userAnswersMap: state.userAnswersMap,
                      status: status,
                    ),
                  ],
                ),
              );
            }

            // State 4: Test disponible à passer (Active Test State)
            return RefreshIndicator(
              color: AppColors.skyBlue,
              onRefresh: () async => _fetchTodayTest(),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                children: [
                  TestQuizCard(quiz: quiz),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
