import 'package:flutter_test/flutter_test.dart';
import 'package:myffsc/features/profile/data/models/user_test_history_model.dart';
import 'package:myffsc/features/tests/domain/entities/question_item_entity.dart';
import 'package:myffsc/features/tests/domain/entities/test_quiz_entity.dart';

void main() {
  group('QuestionItemEntity - checkIsAnswerCorrect & scoring', () {
    const q1 = QuestionItemEntity(
      id: 'q1',
      title: 'Question 1',
      type: 'choice',
      level: 1,
      modules: [1],
      points: 25,
      options: ['Option A', 'Option B', 'Option C', 'Option D'],
      correctAnswers: [1], // 0-based index: Option B
      expectedText: 'Option B',
    );

    test('should match by exact index and reject wrong index', () {
      expect(q1.checkIsAnswerCorrect(1), isTrue);
      expect(q1.checkIsAnswerCorrect(0), isFalse);
      expect(q1.checkIsAnswerCorrect(2), isFalse);
    });

    test('should match by option text and reject wrong text', () {
      expect(q1.checkIsAnswerCorrect('Option B'), isTrue);
      expect(q1.checkIsAnswerCorrect('option b'), isTrue);
      expect(q1.checkIsAnswerCorrect('Option A'), isFalse);
      expect(q1.checkIsAnswerCorrect('Option C'), isFalse);
    });

    test('should match by letter (A, B, C, D)', () {
      expect(q1.checkIsAnswerCorrect('B'), isTrue);
      expect(q1.checkIsAnswerCorrect('b'), isTrue);
      expect(q1.checkIsAnswerCorrect('A'), isFalse);
    });

    test('should handle 1-based indexing when out of bounds of 0-based', () {
      const qOneBased = QuestionItemEntity(
        id: 'q_one_based',
        title: 'Question with 1-based indexing',
        type: 'choice',
        level: 1,
        modules: [1],
        points: 25,
        options: ['First', 'Second', 'Third'],
        correctAnswers: [3], // 3 is out of 0..2 bounds -> means 1-based (index 2: Third)
      );

      // Student provides 0-based index 2 ('Third')
      expect(qOneBased.checkIsAnswerCorrect(2), isTrue);
      // Student provides raw 1-based answer 3
      expect(qOneBased.checkIsAnswerCorrect(3), isTrue);
      // Student provides wrong answer 0
      expect(qOneBased.checkIsAnswerCorrect(0), isFalse);
    });
  });

  group('TestQuizEntity - calculatedTotalPoints', () {
    test('should calculate sum of actual points when totalPoints is 500 or 0', () {
      const quiz = TestQuizEntity(
        id: 'quiz1',
        title: 'Quiz 1',
        description: 'Desc',
        totalDurationMinutes: 10,
        totalPoints: 500, // Invalid fallback
        questions: [
          QuestionItemEntity(
            id: 'q1',
            title: 'Q1',
            type: 'choice',
            level: 1,
            modules: [1],
            points: 25,
          ),
          QuestionItemEntity(
            id: 'q2',
            title: 'Q2',
            type: 'choice',
            level: 1,
            modules: [1],
            points: 25,
          ),
          QuestionItemEntity(
            id: 'q3',
            title: 'Q3',
            type: 'choice',
            level: 1,
            modules: [1],
            points: 25,
          ),
          QuestionItemEntity(
            id: 'q4',
            title: 'Q4',
            type: 'choice',
            level: 1,
            modules: [1],
            points: 25,
          ),
        ],
      );

      expect(quiz.calculatedTotalPoints, equals(100));
    });
  });

  group('UserTestHistoryModel - fromFirestore scoring & total calculation', () {
    test('should never return 500 as totalPossibleScore and compute scores correctly', () {
      final docData = {
        'quizTitle': 'Évaluation Day 1',
        'date': '2026-08-20',
        'score': 0, // was 0 in old doc
        'totalPossibleScore': 500, // was 500 in old doc
        'answers': [
          {
            'questionId': 'q1',
            'score': 25,
            'maxScore': 25,
            'studentAnswer': 'Option A',
            'expectedAnswer': 'Option A',
            'isCorrect': true,
          },
          {
            'questionId': 'q2',
            'score': 25,
            'maxScore': 25,
            'studentAnswer': 'Option B',
            'expectedAnswer': 'Option B',
            'isCorrect': true,
          },
          {
            'questionId': 'q3',
            'score': 0,
            'maxScore': 25,
            'studentAnswer': 'Option C',
            'expectedAnswer': 'Option D',
            'isCorrect': false,
          },
          {
            'questionId': 'q4',
            'score': 25,
            'maxScore': 25,
            'studentAnswer': 'Option A',
            'expectedAnswer': 'Option A',
            'isCorrect': true,
          },
        ],
      };

      final model = UserTestHistoryModel.fromFirestore(
        docId: 'doc_1',
        data: docData,
      );

      // Total possible score should be 100 (4 * 25), NOT 500
      expect(model.totalPossibleScore, equals(100));
      expect(model.displayTotalPossibleScore, equals(100));
      // Score should be calculated as 75 (25 + 25 + 0 + 25), NOT 0
      expect(model.score, equals(75));
      expect(model.percentage, equals(75.0));
    });

    test('should fallback to 100 when totalPossibleScore is missing or 500 and no answers', () {
      final docData = {
        'score': 80,
      };

      final model = UserTestHistoryModel.fromFirestore(
        docId: 'doc_2',
        data: docData,
      );

      expect(model.totalPossibleScore, equals(100));
      expect(model.displayTotalPossibleScore, equals(100));
      expect(model.score, equals(80));
      expect(model.percentage, equals(80.0));
    });
  });
}
