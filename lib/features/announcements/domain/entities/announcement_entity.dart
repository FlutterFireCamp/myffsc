import 'package:equatable/equatable.dart';

class AnnouncementEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final dynamic targetLevel; // 1 | 2 | 3 | 4 | 'all'
  final String priority; // 'normal' | 'important' | 'urgent'
  final String createdAt;
  final String createdBy;

  const AnnouncementEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.targetLevel,
    required this.priority,
    required this.createdAt,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        targetLevel,
        priority,
        createdAt,
        createdBy,
      ];
}
