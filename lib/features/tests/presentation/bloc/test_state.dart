import 'package:equatable/equatable.dart';
import '../../domain/entities/test_quiz_entity.dart';

class TestState extends Equatable {
  final bool isLoading;
  final TestQuizEntity? activeQuiz;
  final bool isSubmittedToday;
  final Map<String, dynamic>? previousSubmission;
  final bool isQuizActive;
  final bool isQuizFinished;
  final int currentQuestionIndex;
  final int remainingSeconds;
  final int bonusTimeBank;
  final Map<int, dynamic> userAnswersMap;
  final int tabSwitchCount;
  final int qcmScore;
  final int totalPossibleScore;
  final bool isSubmittingResult;
  final bool submissionSuccess;
  final String? errorMessage;
  final int totalTimeSpentSeconds;

  const TestState({
    this.isLoading = false,
    this.activeQuiz,
    this.isSubmittedToday = false,
    this.previousSubmission,
    this.isQuizActive = false,
    this.isQuizFinished = false,
    this.currentQuestionIndex = 0,
    this.remainingSeconds = 60,
    this.bonusTimeBank = 0,
    this.userAnswersMap = const {},
    this.tabSwitchCount = 0,
    this.qcmScore = 0,
    this.totalPossibleScore = 100,
    this.isSubmittingResult = false,
    this.submissionSuccess = false,
    this.errorMessage,
    this.totalTimeSpentSeconds = 0,
  });

  TestState copyWith({
    bool? isLoading,
    TestQuizEntity? activeQuiz,
    bool? isSubmittedToday,
    Map<String, dynamic>? previousSubmission,
    bool? isQuizActive,
    bool? isQuizFinished,
    int? currentQuestionIndex,
    int? remainingSeconds,
    int? bonusTimeBank,
    Map<int, dynamic>? userAnswersMap,
    int? tabSwitchCount,
    int? qcmScore,
    int? totalPossibleScore,
    bool? isSubmittingResult,
    bool? submissionSuccess,
    String? errorMessage,
    int? totalTimeSpentSeconds,
  }) {
    return TestState(
      isLoading: isLoading ?? this.isLoading,
      activeQuiz: activeQuiz ?? this.activeQuiz,
      isSubmittedToday: isSubmittedToday ?? this.isSubmittedToday,
      previousSubmission: previousSubmission ?? this.previousSubmission,
      isQuizActive: isQuizActive ?? this.isQuizActive,
      isQuizFinished: isQuizFinished ?? this.isQuizFinished,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      bonusTimeBank: bonusTimeBank ?? this.bonusTimeBank,
      userAnswersMap: userAnswersMap ?? this.userAnswersMap,
      tabSwitchCount: tabSwitchCount ?? this.tabSwitchCount,
      qcmScore: qcmScore ?? this.qcmScore,
      totalPossibleScore: totalPossibleScore ?? this.totalPossibleScore,
      isSubmittingResult: isSubmittingResult ?? this.isSubmittingResult,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      errorMessage: errorMessage,
      totalTimeSpentSeconds: totalTimeSpentSeconds ?? this.totalTimeSpentSeconds,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        activeQuiz,
        isSubmittedToday,
        previousSubmission,
        isQuizActive,
        isQuizFinished,
        currentQuestionIndex,
        remainingSeconds,
        bonusTimeBank,
        userAnswersMap,
        tabSwitchCount,
        qcmScore,
        totalPossibleScore,
        isSubmittingResult,
        submissionSuccess,
        errorMessage,
        totalTimeSpentSeconds,
      ];
}
