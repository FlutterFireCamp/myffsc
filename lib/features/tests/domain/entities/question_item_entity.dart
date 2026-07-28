import 'package:equatable/equatable.dart';

class QuestionItemEntity extends Equatable {
  final String id;
  final String title;
  final String type; // 'choice' | 'text'
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

  @override
  List<Object?> get props => [
        id,
        title,
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
