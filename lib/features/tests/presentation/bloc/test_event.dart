import 'package:equatable/equatable.dart';

abstract class TestEvent extends Equatable {
  const TestEvent();

  @override
  List<Object?> get props => [];
}

class FetchTodayTestEvent extends TestEvent {
  final String userId;
  const FetchTodayTestEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class StartQuizEvent extends TestEvent {
  const StartQuizEvent();
}

class AnswerQuestionEvent extends TestEvent {
  final int questionIndex;
  final dynamic answer;

  const AnswerQuestionEvent({
    required this.questionIndex,
    required this.answer,
  });

  @override
  List<Object?> get props => [questionIndex, answer];
}

class NextQuestionEvent extends TestEvent {
  const NextQuestionEvent();
}

class TimerTickEvent extends TestEvent {
  const TimerTickEvent();
}

class AppBackgroundSwitchedEvent extends TestEvent {
  final String userId;
  const AppBackgroundSwitchedEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class FinishQuizEvent extends TestEvent {
  final String userId;
  const FinishQuizEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ResetQuizEvent extends TestEvent {
  const ResetQuizEvent();
}
