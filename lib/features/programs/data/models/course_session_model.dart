import '../../domain/entities/program_item.dart';

class CourseSessionModel extends ProgramItem {
  const CourseSessionModel({
    required super.id,
    required super.type,
    required super.title,
    required super.description,
    required super.date,
    required super.time,
    super.sessionUrl,
    super.replayUrl,
    super.location,
    super.speaker,
    super.createdAt,
  });

  factory CourseSessionModel.fromMap(Map<String, dynamic> map, String id) {
    return CourseSessionModel(
      id: id,
      type: ProgramType.fromString(map['type'] as String?),
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      sessionUrl: map['sessionUrl'] as String?,
      replayUrl: map['replayUrl'] as String?,
      location: map['location'] as String?,
      speaker: map['speaker'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) : null,
    );
  }
}
