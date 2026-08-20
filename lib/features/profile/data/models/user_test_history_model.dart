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
    final score = (data['score'] as num?)?.toInt() ?? 0;
    final totalPossibleScore =
        (data['totalPossibleScore'] as num?)?.toInt() ?? 500;
    final status = (data['status'] ?? 'Enregistré').toString();
    final quizId = data['quizId'] as String?;
    final rawAnswers = data['answers'] ?? data['questions'];

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
