import '../../domain/entities/course_session_entity.dart';

class CourseSessionModel extends CourseSessionEntity {
  const CourseSessionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.date,
    required super.time,
    required super.level,
    required super.speaker,
    required super.meetingUrl,
    super.replayUrl,
  });

  factory CourseSessionModel.fromMap(Map<String, dynamic> map, String id) {
    return CourseSessionModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      level: map['level'] ?? 'all',
      speaker: map['speaker'] as String? ?? 'Mentor FFSC',
      meetingUrl: map['meetingUrl'] as String? ?? '',
      replayUrl: map['replayUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'level': level,
      'speaker': speaker,
      'meetingUrl': meetingUrl,
      'replayUrl': replayUrl,
    };
  }
}
