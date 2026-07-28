import 'package:equatable/equatable.dart';

class ExerciseAnswer extends Equatable {
  final String questionId;
  final String questionText;
  final String studentAnswer;
  final int? score;

  const ExerciseAnswer({
    required this.questionId,
    required this.questionText,
    required this.studentAnswer,
    this.score,
  });

  factory ExerciseAnswer.fromMap(Map<String, dynamic> map) {
    return ExerciseAnswer(
      questionId: map['questionId'] as String? ?? '',
      questionText: map['questionText'] as String? ?? '',
      studentAnswer: map['studentAnswer'] as String? ?? '',
      score: (map['score'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'studentAnswer': studentAnswer,
      'score': score,
    };
  }

  @override
  List<Object?> get props => [questionId, questionText, studentAnswer, score];
}

class ExerciseSubmissionModel extends Equatable {
  final String id;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String exerciseTitle;
  final String submittedAt;
  final String status; // 'pending' | 'graded'
  final String? gradedByEmail;
  final String? gradedAt;
  final int? totalScore;
  final List<ExerciseAnswer> answers;

  const ExerciseSubmissionModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.exerciseTitle,
    required this.submittedAt,
    required this.status,
    this.gradedByEmail,
    this.gradedAt,
    this.totalScore,
    required this.answers,
  });

  factory ExerciseSubmissionModel.fromMap(Map<String, dynamic> map, String id) {
    return ExerciseSubmissionModel(
      id: id,
      studentId: map['studentId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      studentEmail: map['studentEmail'] as String? ?? '',
      exerciseTitle: map['exerciseTitle'] as String? ?? '',
      submittedAt: map['submittedAt'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      gradedByEmail: map['gradedByEmail'] as String?,
      gradedAt: map['gradedAt'] as String?,
      totalScore: (map['totalScore'] as num?)?.toInt(),
      answers: (map['answers'] as List<dynamic>?)
              ?.map((x) => ExerciseAnswer.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'exerciseTitle': exerciseTitle,
      'submittedAt': submittedAt,
      'status': status,
      'gradedByEmail': gradedByEmail,
      'gradedAt': gradedAt,
      'totalScore': totalScore,
      'answers': answers.map((x) => x.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        studentId,
        studentName,
        studentEmail,
        exerciseTitle,
        submittedAt,
        status,
        gradedByEmail,
        gradedAt,
        totalScore,
        answers,
      ];
}

class QuizSubmissionModel extends Equatable {
  final String id;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final int score;
  final int totalPoints;
  final double percentage;
  final int level;
  final String submittedAt;

  const QuizSubmissionModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.score,
    required this.totalPoints,
    required this.percentage,
    required this.level,
    required this.submittedAt,
  });

  factory QuizSubmissionModel.fromMap(Map<String, dynamic> map, String id) {
    return QuizSubmissionModel(
      id: id,
      studentId: map['studentId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      studentEmail: map['studentEmail'] as String? ?? '',
      score: (map['score'] as num?)?.toInt() ?? 0,
      totalPoints: (map['totalPoints'] as num?)?.toInt() ?? 0,
      percentage: (map['percentage'] as num?)?.toDouble() ?? 0.0,
      level: (map['level'] as num?)?.toInt() ?? 1,
      submittedAt: map['submittedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'score': score,
      'totalPoints': totalPoints,
      'percentage': percentage,
      'level': level,
      'submittedAt': submittedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        studentId,
        studentName,
        studentEmail,
        score,
        totalPoints,
        percentage,
        level,
        submittedAt,
      ];
}
