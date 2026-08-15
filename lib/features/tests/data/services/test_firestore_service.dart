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

  /// Returns true if date corresponds to today (or if null/empty)
  bool _isTodayOrValid(dynamic rawDate) {
    if (rawDate == null) return true;
    final now = DateTime.now();

    if (rawDate is Timestamp) {
      final dt = rawDate.toDate().toLocal();
      return dt.year == now.year && dt.month == now.month && dt.day == now.day;
    }

    if (rawDate is String) {
      final str = rawDate.trim();
      if (str.isEmpty) return true;

      // Try ISO parse
      final parsed = DateTime.tryParse(str);
      if (parsed != null) {
        final dt = parsed.toLocal();
        return dt.year == now.year && dt.month == now.month && dt.day == now.day;
      }

      // Try DD/MM/YYYY or YYYY-MM-DD
      final parts = str.split(RegExp(r'[-/.]'));
      if (parts.length == 3) {
        int? y, m, d;
        if (parts[0].length == 4) {
          y = int.tryParse(parts[0]);
          m = int.tryParse(parts[1]);
          d = int.tryParse(parts[2]);
        } else {
          d = int.tryParse(parts[0]);
          m = int.tryParse(parts[1]);
          y = int.tryParse(parts[2]);
        }
        if (y != null && m != null && d != null) {
          return y == now.year && m == now.month && d == now.day;
        }
      }
    }

    return true; // Default match if format unrecognized
  }

  /// Returns true if status is active/valid
  bool _isValidStatus(dynamic rawStatus) {
    if (rawStatus == null) return true;
    final s = rawStatus.toString().trim().toLowerCase();
    if (s.isEmpty) return true;
    return [
      'active',
      'published',
      'open',
      'scheduled',
      'ongoing',
      'available',
      'true',
      '1'
    ].contains(s);
  }

  /// Fetch active test scheduled for today from /tests
  Future<TestQuizEntity?> fetchTodayTest() async {
    try {
      final snapshot = await _firestore.collection('tests').get();

      if (snapshot.docs.isEmpty) {
        debugPrint("No documents found in /tests collection.");
        return null;
      }

      // 1. First pass: look for status & date match
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final rawDate = data['scheduledDate'] ??
            data['date'] ??
            data['scheduled_date'] ??
            data['scheduledAt'];
        final rawStatus = data['status'];

        if (_isValidStatus(rawStatus) && _isTodayOrValid(rawDate)) {
          final quiz = await _parseTestQuizEntity(doc);
          if (quiz != null && quiz.questions.isNotEmpty) {
            return quiz;
          }
        }
      }

      // 2. Second pass: fallback to any active document in /tests
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final rawStatus = data['status'];

        if (_isValidStatus(rawStatus)) {
          final quiz = await _parseTestQuizEntity(doc);
          if (quiz != null && quiz.questions.isNotEmpty) {
            return quiz;
          }
        }
      }

      // 3. Final fallback: parse the very first doc in /tests
      final firstDoc = snapshot.docs.first;
      return await _parseTestQuizEntity(firstDoc);
    } catch (e) {
      debugPrint("Error fetching today test from Firestore: $e");
    }
    return null;
  }

  /// Fetch a test by its ID from /tests
  Future<TestQuizEntity?> fetchTestById(String quizId) async {
    try {
      final doc = await _firestore.collection('tests').doc(quizId).get();
      if (doc.exists) {
        return await _parseTestQuizEntity(doc);
      }
      final snapshot = await _firestore.collection('tests').get();
      for (final d in snapshot.docs) {
        if (d.id == quizId || d.data()['id'] == quizId) {
          return await _parseTestQuizEntity(d);
        }
      }
    } catch (e) {
      debugPrint("Error fetching test by id: $e");
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

      // Fallback: check any submission in subcollection for this quizId
      final userTestsSnap = await _firestore
          .collection('users')
          .doc(userId)
          .collection('tests')
          .get();

      for (final d in userTestsSnap.docs) {
        final data = d.data();
        if (data['quizId'] == quizId || d.id.startsWith(quizId)) {
          return data;
        }
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

      final hasTextQuestions = quiz.questions.any((q) => q.type != 'choice');
      final String evaluationStatus = hasTextQuestions ? "EN ATTENTE" : "CORRIGÉ";

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
        'status': evaluationStatus,
        'isGraded': !hasTextQuestions,
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

  Future<TestQuizEntity?> _parseTestQuizEntity(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    final data = doc.data() ?? {};
    final docId = doc.id;

    List<dynamic> rawQuestions = (data['questions'] as List<dynamic>?) ??
        (data['items'] as List<dynamic>?) ??
        (data['qcm'] as List<dynamic>?) ??
        [];

    // If root document does not contain questions array, check subcollection /tests/{docId}/questions
    if (rawQuestions.isEmpty) {
      try {
        final subSnap = await doc.reference.collection('questions').get();
        if (subSnap.docs.isNotEmpty) {
          rawQuestions = subSnap.docs.map((d) => d.data()).toList();
        } else {
          final subItemsSnap = await doc.reference.collection('items').get();
          if (subItemsSnap.docs.isNotEmpty) {
            rawQuestions = subItemsSnap.docs.map((d) => d.data()).toList();
          }
        }
      } catch (e) {
        debugPrint("Error fetching questions subcollection: $e");
      }
    }

    final List<QuestionItemEntity> questions = [];
    for (int i = 0; i < rawQuestions.length; i++) {
      if (rawQuestions[i] is! Map<String, dynamic>) continue;
      final qData = rawQuestions[i] as Map<String, dynamic>;

      List<int>? parsedCorrectAnswers;
      if (qData['correctAnswers'] is List) {
        parsedCorrectAnswers = (qData['correctAnswers'] as List)
            .map((e) => (e as num).toInt())
            .toList();
      } else if (qData['correctAnswer'] != null) {
        parsedCorrectAnswers = [(qData['correctAnswer'] as num).toInt()];
      }

      questions.add(QuestionItemEntity(
        id: qData['id'] as String? ?? 'q_$i',
        title: qData['title'] as String? ??
            qData['question'] as String? ??
            'Question ${i + 1}',
        type: qData['type'] as String? ?? 'choice',
        level: (qData['level'] as num?)?.toInt() ?? 1,
        modules: ((qData['modules'] as List<dynamic>?) ?? [1])
            .map((e) => (e as num).toInt())
            .toList(),
        points: (qData['points'] as num?)?.toInt() ?? 25,
        timingSeconds: (qData['timingSeconds'] as num?)?.toInt() ??
            (qData['duration'] as num?)?.toInt() ??
            60,
        options: (qData['options'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        correctAnswers: parsedCorrectAnswers,
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
      totalDurationMinutes: (data['totalDurationMinutes'] as num?)?.toInt() ??
          (data['durationMinutes'] as num?)?.toInt() ??
          10,
      totalPoints:
          (data['totalPoints'] as num?)?.toInt() ?? (questions.length * 25),
      questions: questions,
      status: data['status'] as String? ?? 'active',
    );
  }
}
