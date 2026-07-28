import 'package:equatable/equatable.dart';

class CourseSessionEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final dynamic level; // 1 | 2 | 3 | 4 | 'all'
  final String speaker;
  final String meetingUrl;
  final String? replayUrl;

  const CourseSessionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.level,
    required this.speaker,
    required this.meetingUrl,
    this.replayUrl,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        date,
        time,
        level,
        speaker,
        meetingUrl,
        replayUrl,
      ];
}
