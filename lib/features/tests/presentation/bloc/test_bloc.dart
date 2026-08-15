import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/test_firestore_service.dart';
import 'test_event.dart';
import 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  final TestFirestoreService _firestoreService;
  Timer? _timer;

  TestBloc({TestFirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? TestFirestoreService(),
        super(const TestState()) {
    on<FetchTodayTestEvent>(_onFetchTodayTest);
    on<StartQuizEvent>(_onStartQuiz);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionEvent>(_onNextQuestion);
    on<TimerTickEvent>(_onTimerTick);
    on<AppBackgroundSwitchedEvent>(_onAppBackgroundSwitched);
    on<FinishQuizEvent>(_onFinishQuiz);
    on<ResetQuizEvent>(_onResetQuiz);
  }

  Future<void> _onFetchTodayTest(
    FetchTodayTestEvent event,
    Emitter<TestState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final quiz = await _firestoreService.fetchTodayTest();
    if (quiz == null) {
      emit(state.copyWith(
        isLoading: false,
        activeQuiz: null,
        isSubmittedToday: false,
      ));
      return;
    }

    final submission =
        await _firestoreService.checkUserSubmission(event.userId, quiz.id);

    emit(state.copyWith(
      isLoading: false,
      activeQuiz: quiz,
      isSubmittedToday: submission != null,
      previousSubmission: submission,
    ));
  }

  void _onStartQuiz(
    StartQuizEvent event,
    Emitter<TestState> emit,
  ) {
    if (state.activeQuiz == null || state.activeQuiz!.questions.isEmpty) return;

    _timer?.cancel();
    final firstQuestion = state.activeQuiz!.questions.first;
    final baseSeconds = firstQuestion.timingSeconds ?? 60;

    emit(state.copyWith(
      isQuizActive: true,
      isQuizFinished: false,
      currentQuestionIndex: 0,
      remainingSeconds: baseSeconds,
      bonusTimeBank: 0,
      userAnswersMap: {},
      tabSwitchCount: 0,
      totalTimeSpentSeconds: 0,
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TimerTickEvent());
    });
  }

  void _onTimerTick(
    TimerTickEvent event,
    Emitter<TestState> emit,
  ) {
    if (!state.isQuizActive) return;

    if (state.remainingSeconds > 0) {
      emit(state.copyWith(
        remainingSeconds: state.remainingSeconds - 1,
        totalTimeSpentSeconds: state.totalTimeSpentSeconds + 1,
      ));
    } else {
      // Time up for current question -> advance or finish
      add(const NextQuestionEvent());
    }
  }

  void _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<TestState> emit,
  ) {
    final updatedAnswers = Map<int, dynamic>.from(state.userAnswersMap);
    updatedAnswers[event.questionIndex] = event.answer;
    emit(state.copyWith(userAnswersMap: updatedAnswers));
  }

  void _onNextQuestion(
    NextQuestionEvent event,
    Emitter<TestState> emit,
  ) {
    final quiz = state.activeQuiz;
    if (quiz == null) return;

    final unusedSeconds = state.remainingSeconds;
    final newBonusBank = state.bonusTimeBank + unusedSeconds;

    if (state.currentQuestionIndex < quiz.questions.length - 1) {
      final nextIndex = state.currentQuestionIndex + 1;
      final nextQuestion = quiz.questions[nextIndex];
      final nextBaseSeconds = nextQuestion.timingSeconds ?? 60;

      emit(state.copyWith(
        currentQuestionIndex: nextIndex,
        remainingSeconds: nextBaseSeconds + newBonusBank,
        bonusTimeBank: newBonusBank,
      ));
    } else {
      // Last question -> submit
      _timer?.cancel();
      emit(state.copyWith(isQuizActive: false, isQuizFinished: true));
    }
  }

  void _onAppBackgroundSwitched(
    AppBackgroundSwitchedEvent event,
    Emitter<TestState> emit,
  ) {
    if (!state.isQuizActive) return;

    final newCount = state.tabSwitchCount + 1;
    emit(state.copyWith(tabSwitchCount: newCount));

    if (newCount >= 3) {
      // Trigger automatic submission on 3 warnings
      add(FinishQuizEvent(userId: event.userId));
    }
  }

  Future<void> _onFinishQuiz(
    FinishQuizEvent event,
    Emitter<TestState> emit,
  ) async {
    _timer?.cancel();

    final quiz = state.activeQuiz;
    if (quiz == null) return;

    emit(state.copyWith(
      isQuizActive: false,
      isQuizFinished: true,
      isSubmittingResult: true,
    ));

    // Calculate auto QCM score (25 pts per correct QCM)
    int calculatedScore = 0;
    int totalPossible = 0;

    for (int i = 0; i < quiz.questions.length; i++) {
      final q = quiz.questions[i];
      if (q.type == 'choice') {
        totalPossible += 25;
        final userAnswer = state.userAnswersMap[i];
        if (userAnswer != null &&
            q.correctAnswers != null &&
            q.correctAnswers!.contains(userAnswer)) {
          calculatedScore += 25;
        }
      }
    }

    final success = await _firestoreService.submitTestResult(
      userId: event.userId,
      quiz: quiz,
      userAnswers: state.userAnswersMap,
      score: calculatedScore,
      timeSpentSeconds: state.totalTimeSpentSeconds,
      tabSwitchCount: state.tabSwitchCount,
    );

    emit(state.copyWith(
      isSubmittingResult: false,
      submissionSuccess: success,
      isSubmittedToday: true,
      qcmScore: calculatedScore,
      totalPossibleScore: totalPossible > 0 ? totalPossible : quiz.totalPoints,
    ));
  }

  void _onResetQuiz(
    ResetQuizEvent event,
    Emitter<TestState> emit,
  ) {
    _timer?.cancel();
    emit(state.copyWith(
      isQuizActive: false,
      isQuizFinished: false,
      currentQuestionIndex: 0,
      remainingSeconds: 60,
      bonusTimeBank: 0,
      userAnswersMap: {},
      tabSwitchCount: 0,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
