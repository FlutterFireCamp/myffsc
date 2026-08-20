import 'package:equatable/equatable.dart';

class UserQuestionCorrection extends Equatable {
  final int index;
  final String questionId;
  final String title;
  final String? statement;
  final String type;
  final dynamic studentAnswer;
  final dynamic expectedAnswer;
  final int earnedScore;
  final int maxScore;
  final List<String>? options;
  final List<int>? correctAnswers;
  final String? explanation;

  const UserQuestionCorrection({
    required this.index,
    required this.questionId,
    required this.title,
    this.statement,
    this.type = 'choice',
    required this.studentAnswer,
    this.expectedAnswer,
    required this.earnedScore,
    this.maxScore = 25,
    this.options,
    this.correctAnswers,
    this.explanation,
  });

  bool get isCorrect => earnedScore >= maxScore && earnedScore > 0;
  bool get isChoice => type == 'choice' && options != null && options!.isNotEmpty;

  /// Returns the effective statement to display (statement or title)
  String get displayStatement {
    if (statement != null && statement!.trim().isNotEmpty) {
      return statement!.trim();
    }
    return title.trim();
  }

  @override
  List<Object?> get props => [
        index,
        questionId,
        title,
        statement,
        type,
        studentAnswer,
        expectedAnswer,
        earnedScore,
        maxScore,
        options,
        correctAnswers,
        explanation,
      ];
}
