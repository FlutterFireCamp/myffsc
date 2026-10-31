import '../../domain/entities/user_test_history_entity.dart';

class UserTestHistoryModel extends UserTestHistoryEntity {
  const UserTestHistoryModel({
    required super.docId,
    required super.quizTitle,
    required super.dateStr,
    required super.score,
    required super.totalPossibleScore,
    required super.status,
    super.quizId,
    super.rawAnswers,
  });

  factory UserTestHistoryModel.fromFirestore({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    final dateStr = data['date'] as String? ??
        (RegExp(r'\d{4}-\d{2}-\d{2}').firstMatch(docId)?.group(0) ?? '');
    final quizTitle = data['quizTitle'] as String? ??
        (dateStr.isNotEmpty
            ? "Évaluation FFSC du $dateStr"
            : "Évaluation FFSC");

    final rawAnswers =
        data['answers'] ?? data['questions'] ?? data['items'] ?? data['reponses'];

    // 1. Calculate / extract total possible score (never 500)
    final parsedTotalPossible = (data['totalPossibleScore'] as num?)?.toInt() ??
        (data['totalPossible'] as num?)?.toInt() ??
        (data['totalPoints'] as num?)?.toInt() ??
        (data['maxScore'] as num?)?.toInt() ??
        (data['totalScorePossible'] as num?)?.toInt();

    int computedPossibleFromAnswers = 0;
    int computedScoreFromAnswers = 0;
    bool hasAnswerScores = false;

    void inspectItem(dynamic item) {
      if (item is Map) {
        final maxScore = (item['maxScore'] as num?)?.toInt() ??
            (item['points'] as num?)?.toInt() ??
            25;
        computedPossibleFromAnswers += maxScore;

        final earned = (item['score'] as num?)?.toInt() ??
            (item['earnedScore'] as num?)?.toInt();
        if (earned != null) {
          hasAnswerScores = true;
          computedScoreFromAnswers += earned;
        } else if (item['isCorrect'] == true || item['correct'] == true) {
          hasAnswerScores = true;
          computedScoreFromAnswers += maxScore;
        } else if (item['studentAnswer'] != null &&
            item['expectedAnswer'] != null &&
            item['studentAnswer'].toString().trim().isNotEmpty &&
            item['studentAnswer'].toString().trim() ==
                item['expectedAnswer'].toString().trim()) {
          hasAnswerScores = true;
          computedScoreFromAnswers += maxScore;
        }
      } else {
        computedPossibleFromAnswers += 25;
      }
    }

    if (rawAnswers is List) {
      for (final item in rawAnswers) {
        inspectItem(item);
      }
    } else if (rawAnswers is Map) {
      for (final val in rawAnswers.values) {
        inspectItem(val);
      }
    }

    int totalPossibleScore;
    if (computedPossibleFromAnswers > 0) {
      totalPossibleScore = computedPossibleFromAnswers;
    } else if (parsedTotalPossible != null &&
        parsedTotalPossible > 0 &&
        parsedTotalPossible != 500) {
      totalPossibleScore = parsedTotalPossible;
    } else {
      totalPossibleScore = 100;
    }

    // 2. Calculate / extract user score
    int score = (data['score'] as num?)?.toInt() ??
        (data['totalScore'] as num?)?.toInt() ??
        (data['points'] as num?)?.toInt() ??
        (data['note'] as num?)?.toInt() ??
        (data['qcmScore'] as num?)?.toInt() ??
        0;

    if (score == 0 && hasAnswerScores && computedScoreFromAnswers > 0) {
      score = computedScoreFromAnswers;
    }

    final status = (data['status'] ?? 'Enregistré').toString();
    final quizId = data['quizId'] as String?;

    return UserTestHistoryModel(
      docId: docId,
      quizTitle: quizTitle,
      dateStr: dateStr,
      score: score,
      totalPossibleScore: totalPossibleScore,
      status: status,
      quizId: quizId,
      rawAnswers: rawAnswers,
    );
  }
}
