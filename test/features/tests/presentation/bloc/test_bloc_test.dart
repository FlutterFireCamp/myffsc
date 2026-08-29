import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myffsc/features/tests/data/services/test_firestore_service.dart';
import 'package:myffsc/features/tests/domain/entities/test_quiz_entity.dart';
import 'package:myffsc/features/tests/domain/entities/question_item_entity.dart';
import 'package:myffsc/features/tests/presentation/bloc/test_bloc.dart';
import 'package:myffsc/features/tests/presentation/bloc/test_event.dart';
import 'package:myffsc/features/tests/presentation/bloc/test_state.dart';

class MockTestFirestoreService extends Mock implements TestFirestoreService {}

void main() {
  late MockTestFirestoreService mockFirestoreService;
  late TestBloc testBloc;

  setUp(() {
    mockFirestoreService = MockTestFirestoreService();
    testBloc = TestBloc(firestoreService: mockFirestoreService);
  });

  tearDown(() {
    testBloc.close();
  });

  const tQuiz = TestQuizEntity(
    id: 'quiz_day_1',
    title: 'Test Flutter Basics',
    description: 'Premier QCM du camp',
    totalDurationMinutes: 10,
    totalPoints: 50,
    status: 'active',
    questions: [
      QuestionItemEntity(
        id: 'q1',
        title: 'Quelle est la commande pour créer un projet Flutter ?',
        type: 'choice',
        level: 1,
        modules: [1],
        options: ['flutter run', 'flutter create', 'flutter build'],
        correctAnswers: [1],
        points: 25,
        timingSeconds: 30,
      ),
      QuestionItemEntity(
        id: 'q2',
        title: 'Quel widget est immuable ?',
        type: 'choice',
        level: 1,
        modules: [1],
        options: ['StatefulWidget', 'StatelessWidget'],
        correctAnswers: [1],
        points: 25,
        timingSeconds: 30,
      ),
    ],
  );

  group('TestBloc - FetchTodayTestEvent', () {
    blocTest<TestBloc, TestState>(
      'emits [isLoading: true, activeQuiz: tQuiz] when today test exists',
      build: () {
        when(() => mockFirestoreService.fetchTodayTest())
            .thenAnswer((_) async => tQuiz);
        when(() => mockFirestoreService.checkUserSubmission('user_123', 'quiz_day_1'))
            .thenAnswer((_) async => null);
        return testBloc;
      },
      act: (bloc) => bloc.add(const FetchTodayTestEvent(userId: 'user_123')),
      expect: () => [
        const TestState(isLoading: true),
        const TestState(
          isLoading: false,
          activeQuiz: tQuiz,
          isSubmittedToday: false,
        ),
      ],
    );

    blocTest<TestBloc, TestState>(
      'emits [isLoading: true, activeQuiz: null] when no test exists today',
      build: () {
        when(() => mockFirestoreService.fetchTodayTest())
            .thenAnswer((_) async => null);
        return testBloc;
      },
      act: (bloc) => bloc.add(const FetchTodayTestEvent(userId: 'user_123')),
      expect: () => [
        const TestState(isLoading: true),
        const TestState(
          isLoading: false,
          activeQuiz: null,
          isSubmittedToday: false,
        ),
      ],
    );
  });

  group('TestBloc - Quiz Progression', () {
    blocTest<TestBloc, TestState>(
      'starts quiz properly on StartQuizEvent',
      seed: () => const TestState(activeQuiz: tQuiz),
      build: () => testBloc,
      act: (bloc) => bloc.add(StartQuizEvent()),
      expect: () => [
        isA<TestState>()
            .having((s) => s.isQuizActive, 'isQuizActive', true)
            .having((s) => s.currentQuestionIndex, 'currentQuestionIndex', 0)
            .having((s) => s.remainingSeconds, 'remainingSeconds', 30),
      ],
    );

    blocTest<TestBloc, TestState>(
      'records user answer on AnswerQuestionEvent',
      seed: () => const TestState(activeQuiz: tQuiz, isQuizActive: true),
      build: () => testBloc,
      act: (bloc) => bloc.add(const AnswerQuestionEvent(questionIndex: 0, answer: 1)),
      expect: () => [
        isA<TestState>().having(
          (s) => s.userAnswersMap[0],
          'answer for q0',
          1,
        ),
      ],
    );

    blocTest<TestBloc, TestState>(
      'resets quiz properly on ResetQuizEvent',
      seed: () => const TestState(isQuizActive: true, isQuizFinished: true),
      build: () => testBloc,
      act: (bloc) => bloc.add(ResetQuizEvent()),
      expect: () => [
        const TestState(),
      ],
    );
  });
}
