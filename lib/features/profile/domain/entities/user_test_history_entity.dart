import 'package:equatable/equatable.dart';

class UserTestHistoryEntity extends Equatable {
  final String docId;
  final String quizTitle;
  final String dateStr;
  final int score;
  final int totalPossibleScore;
  final String status;
  final String? quizId;
  final dynamic rawAnswers;

  const UserTestHistoryEntity({
    required this.docId,
    required this.quizTitle,
    required this.dateStr,
    required this.score,
    required this.totalPossibleScore,
    required this.status,
    this.quizId,
    this.rawAnswers,
  });

  /// Sanitized total possible score avoiding invalid 500 fallbacks
  int get displayTotalPossibleScore =>
      (totalPossibleScore > 0 && totalPossibleScore != 500)
          ? totalPossibleScore
          : 100;

  double get percentage =>
      displayTotalPossibleScore > 0 ? (score / displayTotalPossibleScore) * 100 : 0.0;

  @override
  List<Object?> get props => [
        docId,
        quizTitle,
        dateStr,
        score,
        totalPossibleScore,
        status,
        quizId,
        rawAnswers,
      ];
}
