import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../tests/data/services/test_firestore_service.dart';
import '../../../tests/domain/entities/test_quiz_entity.dart';
import '../../../tests/domain/entities/user_question_correction.dart';
import '../models/user_test_history_model.dart';

abstract class ProfileRemoteDataSource {
  Stream<List<UserTestHistoryModel>> streamUserTestHistory(String userId);
  Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  });
  Future<List<UserQuestionCorrection>> getTestCorrectionDetails({
    required String? quizId,
    required String dateStr,
    required String docId,
    required dynamic rawAnswers,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final TestFirestoreService testFirestoreService;

  ProfileRemoteDataSourceImpl({
    required this.firestore,
    required this.testFirestoreService,
  });

  @override
  Stream<List<UserTestHistoryModel>> streamUserTestHistory(String userId) {
    dev.log('Streaming test history for user: $userId', name: 'PROFILE_REMOTE_DS');
    return firestore
        .collection('users')
        .doc(userId)
        .collection('tests')
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return UserTestHistoryModel.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        );
      }).toList();

      // Sort by date descending
      list.sort((a, b) {
        final dateComp = b.dateStr.compareTo(a.dateStr);
        if (dateComp != 0) return dateComp;
        return b.docId.compareTo(a.docId);
      });

      return list;
    });
  }

  @override
  Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      dev.log('Updating profile in Firestore for user $userId', name: 'PROFILE_REMOTE_DS');
      final updateData = Map<String, dynamic>.from(data);
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await firestore.collection('users').doc(userId).update(updateData);
    } catch (e, st) {
      dev.log('Error updating profile in Firestore', name: 'PROFILE_REMOTE_DS', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<UserQuestionCorrection>> getTestCorrectionDetails({
    required String? quizId,
    required String dateStr,
    required String docId,
    required dynamic rawAnswers,
  }) async {
    try {
      dev.log('Fetching test correction details for docId: $docId, quizId: $quizId', name: 'PROFILE_REMOTE_DS');
      TestQuizEntity? mainQuiz;
      try {
        mainQuiz = await testFirestoreService.fetchTestBySubmission(
          quizId: quizId,
          date: dateStr,
          docId: docId,
        );
      } catch (e, st) {
        dev.log(
          'Erreur lors du chargement de la définition du test depuis /tests',
          name: 'PROFILE_REMOTE_DS',
          error: e,
          stackTrace: st,
        );
      }

      // Parse user submission answers from /users/{userId}/tests/{docId}
      final List<Map<String, dynamic>> userAnswersList = [];

      if (rawAnswers is List) {
        for (final item in rawAnswers) {
          if (item is Map) {
            userAnswersList.add(Map<String, dynamic>.from(item));
          } else {
            userAnswersList.add({'studentAnswer': item.toString()});
          }
        }
      } else if (rawAnswers is Map) {
        final sortedKeys = rawAnswers.keys.toList()
          ..sort((a, b) {
            final matchA = RegExp(r'\d+').firstMatch(a.toString());
            final matchB = RegExp(r'\d+').firstMatch(b.toString());
            final intA =
                matchA != null ? (int.tryParse(matchA.group(0)!) ?? 0) : 0;
            final intB =
                matchB != null ? (int.tryParse(matchB.group(0)!) ?? 0) : 0;
            if (intA != intB) return intA.compareTo(intB);
            return a.toString().compareTo(b.toString());
          });

        for (final key in sortedKeys) {
          final val = rawAnswers[key];
          if (val is Map) {
            final mapVal = Map<String, dynamic>.from(val);
            if (!mapVal.containsKey('questionId')) {
              mapVal['questionId'] = key.toString();
            }
            userAnswersList.add(mapVal);
          } else {
            userAnswersList.add({
              'questionId': key.toString(),
              'studentAnswer': val.toString(),
            });
          }
        }
      }

      // Merge: Combine /tests principal test questions with user subcollection answers
      final List<UserQuestionCorrection> corrections = [];
      final int questionCount =
          mainQuiz != null && mainQuiz.questions.isNotEmpty
              ? mainQuiz.questions.length
              : userAnswersList.length;

      for (int i = 0; i < questionCount; i++) {
        final mainQ = (mainQuiz != null && i < mainQuiz.questions.length)
            ? mainQuiz.questions[i]
            : null;

        // Find user answer by matching questionId, title or fallback to index i
        Map<String, dynamic>? userAnsData;
        if (mainQ != null) {
          for (final ans in userAnswersList) {
            final qId = ans['questionId']?.toString();
            if (qId != null &&
                (qId == mainQ.id ||
                    qId == "q_${i + 1}" ||
                    qId == "q$i" ||
                    qId == i.toString() ||
                    qId == (i + 1).toString())) {
              userAnsData = ans;
              break;
            }
          }
        }
        userAnsData ??= (i < userAnswersList.length ? userAnswersList[i] : null);

        final studentAns = userAnsData != null
            ? (userAnsData['studentAnswer'] ??
                  userAnsData['answer'] ??
                  userAnsData['userAnswer'])
            : "-1";

        int earnedScore =
            (userAnsData?['score'] as num?)?.toInt() ??
            (userAnsData?['earnedScore'] as num?)?.toInt() ??
            0;

        if (earnedScore == 0 && mainQ != null && studentAns != "-1") {
          if (mainQ.checkIsAnswerCorrect(studentAns)) {
            earnedScore = mainQ.actualPoints;
          }
        } else if (earnedScore == 0 && userAnsData != null) {
          if (userAnsData['isCorrect'] == true || userAnsData['correct'] == true) {
            earnedScore = (userAnsData['maxScore'] as num?)?.toInt() ??
                (userAnsData['points'] as num?)?.toInt() ??
                25;
          } else if (userAnsData['expectedAnswer'] != null &&
              userAnsData['expectedAnswer'].toString().trim().isNotEmpty &&
              userAnsData['expectedAnswer'].toString().trim() == studentAns.toString().trim()) {
            earnedScore = (userAnsData['maxScore'] as num?)?.toInt() ??
                (userAnsData['points'] as num?)?.toInt() ??
                25;
          }
        }

        final expectedAns =
            userAnsData?['expectedAnswer']?.toString() ??
            userAnsData?['expectedText']?.toString() ??
            mainQ?.expectedText;

        final questionId = mainQ?.id ?? "q_$i";

        final questionTitle = (mainQ != null && mainQ.title.isNotEmpty)
            ? mainQ.title
            : (userAnsData?['questionText'] as String? ?? "Question ${i + 1}");

        final questionStatement = (mainQ != null && (mainQ.statement?.isNotEmpty ?? false))
            ? mainQ.statement
            : (userAnsData?['statement'] as String? ??
                  userAnsData?['question'] as String? ??
                  questionTitle);

        final questionOptions = mainQ?.options ??
            (userAnsData?['options'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        final questionType = mainQ?.type ??
            (userAnsData?['type'] as String? ??
                (questionOptions.isNotEmpty ? 'choice' : 'open'));

        final correctAnswers = mainQ?.correctAnswers ??
            (userAnsData?['correctAnswers'] as List?)
                ?.map((e) => (e as num).toInt())
                .toList();

        final explanation = mainQ?.explanation ??
            userAnsData?['explanation'] as String?;

        corrections.add(
          UserQuestionCorrection(
            index: i,
            questionId: questionId,
            title: questionTitle,
            statement: questionStatement,
            type: questionType,
            studentAnswer: studentAns,
            earnedScore: earnedScore,
            maxScore: mainQ?.actualPoints ??
                (userAnsData?['maxScore'] as num?)?.toInt() ??
                (userAnsData?['points'] as num?)?.toInt() ??
                25,
            expectedAnswer: expectedAns,
            options: questionOptions,
            correctAnswers: correctAnswers,
            explanation: explanation,
          ),
        );
      }

      return corrections;
    } catch (e, st) {
      dev.log('Error getting test correction details', name: 'PROFILE_REMOTE_DS', error: e, stackTrace: st);
      rethrow;
    }
  }
}
