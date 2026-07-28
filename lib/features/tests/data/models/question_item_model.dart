import '../../domain/entities/question_item_entity.dart';

class QuestionItemModel extends QuestionItemEntity {
  const QuestionItemModel({
    required super.id,
    required super.title,
    required super.type,
    required super.level,
    required super.modules,
    required super.points,
    super.timingSeconds,
    super.options,
    super.correctAnswers,
    super.optionExplanations,
    super.expectedText,
    super.explanation,
    super.createdAt,
    super.updatedAt,
  });

  factory QuestionItemModel.fromMap(Map<String, dynamic> map, String id) {
    return QuestionItemModel(
      id: id,
      title: map['title'] as String? ?? '',
      type: map['type'] as String? ?? 'choice',
      level: (map['level'] as num?)?.toInt() ?? 1,
      modules: (map['modules'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? [1],
      points: (map['points'] as num?)?.toInt() ?? 10,
      timingSeconds: (map['timingSeconds'] as num?)?.toInt(),
      options: (map['options'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      correctAnswers: (map['correctAnswers'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
      optionExplanations: (map['optionExplanations'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      expectedText: map['expectedText'] as String?,
      explanation: map['explanation'] as String?,
      createdAt: map['createdAt']?.toString(),
      updatedAt: map['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'level': level,
      'modules': modules,
      'points': points,
      'timingSeconds': timingSeconds,
      'options': options,
      'correctAnswers': correctAnswers,
      'optionExplanations': optionExplanations,
      'expectedText': expectedText,
      'explanation': explanation,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
