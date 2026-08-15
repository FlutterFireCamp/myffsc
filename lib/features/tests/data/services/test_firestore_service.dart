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
          return _parseTestQuizEntity(doc.id, data);
        }
      }

      // Fallback: If no document matches exact scheduledDate in /tests, check for any active test doc
      if (snapshot.docs.isNotEmpty) {
        final activeDoc = snapshot.docs.firstWhere(
          (doc) => (doc.data()['status'] as String? ?? 'active') == 'active',
          orElse: () => snapshot.docs.first,
        );
        return _parseTestQuizEntity(activeDoc.id, activeDoc.data());
      }
    } catch (e) {
      debugPrint("Error fetching today test: $e");
    }
    return _createMockEvaluationIfEmpty();
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

  TestQuizEntity _parseTestQuizEntity(String docId, Map<String, dynamic> data) {
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
      return _createDefaultQuiz(docId, data);
    }

    return TestQuizEntity(
      id: docId,
      title: data['title'] as String? ?? "Examen de Validation FFSC 2026",
      description: data['description'] as String? ??
          "Évaluation officielle couvrant la logique Dart et les composants Flutter.",
      totalDurationMinutes: (data['totalDurationMinutes'] as num?)?.toInt() ?? 10,
      totalPoints: (data['totalPoints'] as num?)?.toInt() ?? 100,
      questions: questions,
      status: data['status'] as String? ?? 'active',
    );
  }

  TestQuizEntity _createDefaultQuiz(String id, Map<String, dynamic> data) {
    return _createMockEvaluationIfEmpty();
  }

  TestQuizEntity _createMockEvaluationIfEmpty() {
    return const TestQuizEntity(
      id: "ffsc_exam_2026",
      title: "Examen de Validation FFSC 2026",
      description:
          "Test officiel hybride couvrant la syntaxe Dart, le state management Flutter et les principes d'optimisation.",
      totalDurationMinutes: 10,
      totalPoints: 100,
      status: "active",
      questions: [
        QuestionItemEntity(
          id: "q1",
          title:
              "Quelle est la différence fondamentale entre les mots-clés `final` et `const` en Dart ?",
          type: "choice",
          level: 1,
          modules: [1],
          points: 25,
          timingSeconds: 60,
          options: [
            "`final` est évalué à la compilation, `const` à l'exécution.",
            "`const` est une constante à la compilation, `final` est initialisé une seule fois à l'exécution.",
            "Il n'y a aucune différence, ce sont de simples synonymes.",
            "`final` ne s'applique qu'aux classes, `const` aux fonctions."
          ],
          correctAnswers: [1],
          explanation:
              "`const` crée des constantes au moment de la compilation (compile-time constant), tandis que `final` est assigné une seule fois lors du runtime.",
        ),
        QuestionItemEntity(
          id: "q2",
          title:
              "Quel widget Flutter est recommandé pour construire des listes très longues ou infinies de manière performante ?",
          type: "choice",
          level: 2,
          modules: [2],
          points: 25,
          timingSeconds: 60,
          options: [
            "ListView classique avec children",
            "SingleChildScrollView avec Column",
            "ListView.builder avec un itemBuilder lazy",
            "Stack avec Positioned"
          ],
          correctAnswers: [2],
          explanation:
              "`ListView.builder` instancie et détruit dynamiquement les éléments visibles à l'écran, économisant ainsi la mémoire.",
        ),
        QuestionItemEntity(
          id: "q3",
          title:
              "Comment empêcher la reconstruction inutile d'un widget Stateless quand ses dépendances ne changent pas ?",
          type: "choice",
          level: 2,
          modules: [2],
          points: 25,
          timingSeconds: 60,
          options: [
            "En utilisant le constructeur `const`",
            "En appelant setState() dans build",
            "En encapsulant le widget dans un Timer",
            "En utilisant dynamic au lieu de Widget"
          ],
          correctAnswers: [0],
          explanation:
              "Utiliser `const` permet à Flutter de réutiliser la même instance de widget en mémoire sans re-exécuter la méthode build.",
        ),
        QuestionItemEntity(
          id: "q4",
          title:
              "Question Pratique : Écrivez un snippet Dart qui filtre une liste d'entiers `[1, 2, 3, 4, 5, 6]` pour ne garder que les nombres pairs.",
          type: "text",
          level: 3,
          modules: [1, 2],
          points: 25,
          timingSeconds: 120,
          expectedText: "numbers.where((n) => n.isEven).toList()",
          explanation:
              "La méthode `.where()` combinée avec la propriété `.isEven` de int est l'approche idiatique en Dart.",
        ),
      ],
    );
  }
}
