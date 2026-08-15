import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/question_item_entity.dart';
import '../../domain/entities/test_quiz_entity.dart';

class TestFirestoreService {
  final FirebaseFirestore _firestore;

  TestFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  String get _todayDateFormatted {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  /// Fetch active test scheduled for today from /tests
  Future<TestQuizEntity?> fetchTodayTest() async {
    try {
      final snapshot = await _firestore.collection('tests').get();
      final todayStr = _todayDateFormatted;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final scheduledDate = data['scheduledDate'] as String?;
        final status = data['status'] as String? ?? 'active';

        // Check if scheduled date matches today or if test is marked active
        final isDateMatch = scheduledDate == null || scheduledDate == todayStr;
        if (status == 'active' && isDateMatch) {
          final quiz = _parseTestQuizEntity(doc.id, data);
          if (quiz != null) return quiz;
        }
      }

      // Fallback: Check for any active test doc in /tests
      if (snapshot.docs.isNotEmpty) {
        for (final doc in snapshot.docs) {
          final data = doc.data();
          if ((data['status'] as String? ?? 'active') == 'active') {
            final quiz = _parseTestQuizEntity(doc.id, data);
            if (quiz != null) return quiz;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching today test: $e");
    }
    return null;
  }

  /// Check if user has already submitted the test today under /users/{userId}/tests/{quizId}_{YYYY-MM-DD}
  Future<Map<String, dynamic>?> checkUserSubmission(
      String userId, String quizId) async {
    try {
      final docId = "${quizId}_$_todayDateFormatted";
      final docRef =
          _firestore.collection('users').doc(userId).collection('tests').doc(docId);

      final snapshot = await docRef.get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data();
      }
    } catch (e) {
      debugPrint("Error checking submission: $e");
    }
    return null;
  }

  /// Submit test result to /users/{userId}/tests/{quizId}_{YYYY-MM-DD} using SetOptions(merge: true)
  Future<bool> submitTestResult({
    required String userId,
    required TestQuizEntity quiz,
    required Map<int, dynamic> userAnswers,
    required int score,
    required int timeSpentSeconds,
    required int tabSwitchCount,
  }) async {
    try {
      final docId = "${quiz.id}_$_todayDateFormatted";
      final docRef =
          _firestore.collection('users').doc(userId).collection('tests').doc(docId);

      // Check if doc already exists to prevent duplicate submission
      final existingDoc = await docRef.get();
      if (existingDoc.exists && (existingDoc.data()?['submitted'] == true)) {
        debugPrint("Test already submitted for today.");
        return true;
      }

      // Convert answers map to JSON string map
      final Map<String, dynamic> formattedAnswers = {};
      userAnswers.forEach((index, value) {
        formattedAnswers[index.toString()] = value;
      });

      final totalPossible = quiz.questions
              .where((q) => q.type == 'choice')
              .length *
          25;

      final submissionData = {
        'quizId': quiz.id,
        'quizTitle': quiz.title,
        'submittedAt': FieldValue.serverTimestamp(),
        'date': _todayDateFormatted,
        'score': score,
        'totalPossibleScore': totalPossible > 0 ? totalPossible : quiz.totalPoints,
        'timeSpentSeconds': timeSpentSeconds,
        'tabSwitchCount': tabSwitchCount,
        'answers': formattedAnswers,
        'submitted': true,
      };

      // Safely set document with merge: true
      await docRef.set(submissionData, SetOptions(merge: true));

      // Update user total points in /users/{userId}
      if (score > 0) {
        await _firestore.collection('users').doc(userId).update({
          'totalPoints': FieldValue.increment(score),
        });
      }

      return true;
    } catch (e) {
      debugPrint("Error submitting test result: $e");
      return false;
    }
  }

  TestQuizEntity? _parseTestQuizEntity(String docId, Map<String, dynamic> data) {
    final rawQuestions = data['questions'] as List<dynamic>? ?? [];
    final List<QuestionItemEntity> questions = [];

    for (int i = 0; i < rawQuestions.length; i++) {
      final qData = rawQuestions[i] as Map<String, dynamic>;
      questions.add(QuestionItemEntity(
        id: qData['id'] as String? ?? 'q_$i',
        title: qData['title'] as String? ?? 'Question ${i + 1}',
        type: qData['type'] as String? ?? 'choice',
        level: (qData['level'] as num?)?.toInt() ?? 1,
        modules: ((qData['modules'] as List<dynamic>?) ?? [1])
            .map((e) => (e as num).toInt())
            .toList(),
        points: (qData['points'] as num?)?.toInt() ?? 25,
        timingSeconds: (qData['timingSeconds'] as num?)?.toInt() ?? 60,
        options: (qData['options'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        correctAnswers: (qData['correctAnswers'] as List<dynamic>?)
            ?.map((e) => (e as num).toInt())
            .toList(),
        optionExplanations: (qData['optionExplanations'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        expectedText: qData['expectedText'] as String?,
        explanation: qData['explanation'] as String?,
      ));
    }

    if (questions.isEmpty) {
      return null;
    }

    return TestQuizEntity(
      id: docId,
      title: data['title'] as String? ?? "Examen de Validation FFSC",
      description: data['description'] as String? ??
          "Évaluation officielle couvrant la logique Dart et les composants Flutter.",
      totalDurationMinutes: (data['totalDurationMinutes'] as num?)?.toInt() ?? 10,
      totalPoints: (data['totalPoints'] as num?)?.toInt() ?? 100,
      questions: questions,
      status: data['status'] as String? ?? 'active',
    );
  }
}
