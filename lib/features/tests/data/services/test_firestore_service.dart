import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/helpers/date_time_helper.dart';
import '../../domain/entities/question_item_entity.dart';
import '../../domain/entities/test_quiz_entity.dart';

class TestFirestoreService {
  final FirebaseFirestore _firestore;

  TestFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  String get _todayDateFormatted => DateTimeHelper.formatYmd(DateTime.now());

  /// Returns true if date corresponds to today (or if null/empty)
  bool _isTodayOrValid(dynamic rawDate) {
    if (rawDate == null) return true;
    final localDt = DateTimeHelper.parseToLocal(rawDate);
    if (localDt == null) return true;
    return DateTimeHelper.isToday(localDt);
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
      dev.log('Recherche du test du jour dans /tests...', name: 'TEST_FIRESTORE_SERVICE');
      final snapshot = await _firestore.collection('tests').get();

      if (snapshot.docs.isEmpty) {
        dev.log('Aucun document trouvé dans la collection /tests.', name: 'TEST_FIRESTORE_SERVICE');
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
            dev.log('Test du jour trouvé avec succès: ${quiz.title}', name: 'TEST_FIRESTORE_SERVICE');
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
            dev.log('Test actif de repli trouvé: ${quiz.title}', name: 'TEST_FIRESTORE_SERVICE');
            return quiz;
          }
        }
      }

      // 3. Final fallback: parse the very first doc in /tests
      final firstDoc = snapshot.docs.first;
      return await _parseTestQuizEntity(firstDoc);
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la récupération du test du jour',
        name: 'TEST_FIRESTORE_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  /// Fetch test definition from principal /tests collection matching quizId, date or docId
  Future<TestQuizEntity?> fetchTestBySubmission({
    String? quizId,
    String? date,
    String? docId,
  }) async {
    try {
      dev.log(
        'Recherche du test dans /tests (quizId: $quizId, date: $date, docId: $docId)',
        name: 'TEST_FIRESTORE_SERVICE',
      );

      // 1. Check direct quizId in /tests if given
      if (quizId != null && quizId.trim().isNotEmpty) {
        final doc = await _firestore.collection('tests').doc(quizId.trim()).get();
        if (doc.exists) {
          final parsed = await _parseTestQuizEntity(doc);
          if (parsed != null && parsed.questions.isNotEmpty) return parsed;
        }
      }

      // 2. Extract date pattern (e.g. 2026-08-15) from date or docId
      String? dateTarget = date?.trim();
      if (dateTarget == null || dateTarget.isEmpty) {
        final match = RegExp(r'\d{4}-\d{2}-\d{2}').firstMatch(docId ?? '');
        if (match != null) {
          dateTarget = match.group(0);
        }
      }

      if (dateTarget != null && dateTarget.isNotEmpty) {
        final doc = await _firestore.collection('tests').doc(dateTarget).get();
        if (doc.exists) {
          final parsed = await _parseTestQuizEntity(doc);
          if (parsed != null && parsed.questions.isNotEmpty) return parsed;
        }
      }

      // 3. Scan documents in /tests
      final snapshot = await _firestore.collection('tests').get();
      for (final d in snapshot.docs) {
        final data = d.data();
        final docDate = (data['date'] ?? data['scheduledDate'] ?? data['scheduled_date'])?.toString();
        if (d.id == quizId ||
            d.id == dateTarget ||
            (dateTarget != null && d.id.contains(dateTarget)) ||
            (dateTarget != null && docDate != null && docDate.contains(dateTarget)) ||
            (quizId != null && (d.id.contains(quizId) || quizId.contains(d.id)))) {
          final parsed = await _parseTestQuizEntity(d);
          if (parsed != null && parsed.questions.isNotEmpty) return parsed;
        }
      }

      // 4. Fallback to any active or first available test in /tests
      for (final d in snapshot.docs) {
        final parsed = await _parseTestQuizEntity(d);
        if (parsed != null && parsed.questions.isNotEmpty) return parsed;
      }
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la récupération du test dans /tests',
        name: 'TEST_FIRESTORE_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  /// Fetch a test by its ID from /tests
  Future<TestQuizEntity?> fetchTestById(String quizId) async {
    return fetchTestBySubmission(quizId: quizId);
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
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la vérification de la soumission de test pour $userId (quiz: $quizId)',
        name: 'TEST_FIRESTORE_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
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
        dev.log('Test déjà soumis aujourd’hui pour $userId (docId: $docId)', name: 'TEST_FIRESTORE_SERVICE');
        return true;
      }

      // Build structured answers list matching [{ questionId, questionText, score, studentAnswer, expectedAnswer }]
      final List<Map<String, dynamic>> answersList = [];
      for (int i = 0; i < quiz.questions.length; i++) {
        final q = quiz.questions[i];
        final rawAns = userAnswers[i];
        final studentAnsStr = rawAns != null ? rawAns.toString() : "-1";

        bool isCorrect = false;
        if (q.type == 'choice' && q.correctAnswers != null && rawAns != null) {
          final intAns = rawAns is int ? rawAns : int.tryParse(rawAns.toString());
          if (intAns != null) {
            isCorrect = q.correctAnswers!.contains(intAns) ||
                q.correctAnswers!.contains(intAns - 1) ||
                q.correctAnswers!.contains(intAns + 1);
          }
        }

        final questionScore = isCorrect ? q.points : 0;
        final expectedAnswerStr = (q.options != null && q.correctAnswers != null && q.correctAnswers!.isNotEmpty)
            ? (q.correctAnswers!.first < q.options!.length ? q.options![q.correctAnswers!.first] : "")
            : (q.expectedText ?? "");

        answersList.add({
          'questionId': q.id,
          'questionText': q.title,
          'score': questionScore,
          'studentAnswer': studentAnsStr,
          'expectedAnswer': expectedAnswerStr,
        });
      }

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
        'answers': answersList,
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

      dev.log(
        'Test soumis avec succès pour $userId: score=$score, status=$evaluationStatus',
        name: 'TEST_FIRESTORE_SERVICE',
      );

      return true;
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la soumission du test pour $userId (quiz: ${quiz.id})',
        name: 'TEST_FIRESTORE_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<TestQuizEntity?> _parseTestQuizEntity(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    final data = doc.data() ?? {};
    final docId = doc.id;

    final rawField = data['questions'] ?? data['items'] ?? data['qcm'];
    final List<dynamic> rawQuestions = [];
    if (rawField is List) {
      rawQuestions.addAll(rawField);
    } else if (rawField is Map) {
      final sortedKeys = rawField.keys.toList()
        ..sort((a, b) {
          final intA = int.tryParse(a.toString()) ?? 0;
          final intB = int.tryParse(b.toString()) ?? 0;
          return intA.compareTo(intB);
        });
      for (final k in sortedKeys) {
        rawQuestions.add(rawField[k]);
      }
    }

    final List<QuestionItemEntity> questions = [];
    for (int i = 0; i < rawQuestions.length; i++) {
      if (rawQuestions[i] is! Map) continue;
      final qData = Map<String, dynamic>.from(rawQuestions[i] as Map);

      String statement = qData['statement'] as String? ??
          qData['enonce'] as String? ??
          qData['description'] as String? ??
          '';

      String title = qData['title'] as String? ??
          qData['question'] as String? ??
          qData['label'] as String? ??
          '';

      final contextStr = qData['context'] as String? ??
          qData['contexte'] as String? ??
          qData['scenario'] as String?;

      if (contextStr != null && contextStr.trim().isNotEmpty) {
        if (statement.isNotEmpty) {
          statement = "**Contexte :**\n${contextStr.trim()}\n\n**Énoncé :**\n$statement";
        } else if (title.isNotEmpty) {
          statement = "**Contexte :**\n${contextStr.trim()}\n\n**Énoncé :**\n$title";
        } else {
          statement = "**Contexte :**\n${contextStr.trim()}";
        }
      }

      if (statement.isEmpty && title.isNotEmpty) {
        statement = title;
      }
      if (title.isEmpty && statement.isNotEmpty) {
        title = statement;
      }
      if (title.isEmpty) {
        title = "Question ${i + 1}";
        statement = title;
      }

      // Parse options (supports List or Map)
      List<String>? options;
      if (qData['options'] is List) {
        options = (qData['options'] as List).map((e) {
          if (e is Map) {
            return (e['text'] ?? e['option'] ?? e['title'] ?? e.toString()).toString();
          }
          return e.toString();
        }).toList();
      } else if (qData['options'] is Map) {
        final optMap = qData['options'] as Map;
        final sortedOptKeys = optMap.keys.toList()
          ..sort((a, b) {
            final intA = int.tryParse(a.toString()) ?? 0;
            final intB = int.tryParse(b.toString()) ?? 0;
            return intA.compareTo(intB);
          });
        options = sortedOptKeys.map((k) {
          final val = optMap[k];
          if (val is Map) {
            return (val['text'] ?? val['option'] ?? val['title'] ?? val.toString()).toString();
          }
          return val.toString();
        }).toList();
      }

      // Parse correct answers
      List<int>? parsedCorrectAnswers;
      if (qData['correctAnswers'] is List) {
        parsedCorrectAnswers = (qData['correctAnswers'] as List).map((e) {
          if (e is num) return e.toInt();
          final parsed = int.tryParse(e.toString());
          return parsed ?? 0;
        }).toList();
      } else if (qData['correctAnswer'] != null) {
        if (qData['correctAnswer'] is num) {
          parsedCorrectAnswers = [(qData['correctAnswer'] as num).toInt()];
        } else {
          final parsed = int.tryParse(qData['correctAnswer'].toString());
          if (parsed != null) {
            parsedCorrectAnswers = [parsed];
          }
        }
      }

      List<int> parsedModules = [1];
      if (qData['modules'] is List) {
        parsedModules = (qData['modules'] as List)
            .map((e) => (e is num) ? e.toInt() : (int.tryParse(e.toString()) ?? 1))
            .toList();
      }

      final expectedText = qData['expectedText'] as String? ??
          qData['expectedAnswer'] as String? ??
          qData['reponseAttendue'] as String?;

      questions.add(QuestionItemEntity(
        id: qData['id'] as String? ?? 'q_$i',
        title: title,
        statement: statement,
        type: qData['type'] as String? ?? (options != null && options.isNotEmpty ? 'choice' : 'open'),
        level: (qData['level'] as num?)?.toInt() ?? 1,
        modules: parsedModules,
        points: (qData['points'] as num?)?.toInt() ?? 25,
        timingSeconds: (qData['timingSeconds'] as num?)?.toInt() ??
            (qData['duration'] as num?)?.toInt() ??
            60,
        options: options,
        correctAnswers: parsedCorrectAnswers,
        optionExplanations: (qData['optionExplanations'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        expectedText: expectedText,
        explanation: qData['explanation'] as String?,
      ));
    }

    if (questions.isEmpty) {
      return null;
    }

    return TestQuizEntity(
      id: docId,
      title: data['title'] as String? ?? "Évaluation FFSC",
      description: data['description'] as String? ??
          "Évaluation officielle FFSC.",
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
