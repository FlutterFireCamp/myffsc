import 'package:equatable/equatable.dart';

class QuestionItemEntity extends Equatable {
  final String id;
  final String title;
  final String? statement;
  final String type; // 'choice' | 'text' | 'open'
  final int level;
  final List<int> modules;
  final int points;
  final int? timingSeconds;
  final List<String>? options;
  final List<int>? correctAnswers;
  final List<String>? optionExplanations;
  final String? expectedText;
  final String? explanation;
  final String? createdAt;
  final String? updatedAt;

  const QuestionItemEntity({
    required this.id,
    required this.title,
    this.statement,
    required this.type,
    required this.level,
    required this.modules,
    required this.points,
    this.timingSeconds,
    this.options,
    this.correctAnswers,
    this.optionExplanations,
    this.expectedText,
    this.explanation,
    this.createdAt,
    this.updatedAt,
  });

  String get displayStatement {
    if (statement != null && statement!.trim().isNotEmpty) {
      return statement!.trim();
    }
    return title.trim();
  }

  @override
  List<Object?> get props => [
        id,
        title,
        statement,
        type,
        level,
        modules,
        points,
        timingSeconds,
        options,
        correctAnswers,
        optionExplanations,
        expectedText,
        explanation,
        createdAt,
        updatedAt,
      ];
}
