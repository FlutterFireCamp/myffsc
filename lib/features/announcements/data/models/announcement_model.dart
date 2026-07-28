import '../../domain/entities/announcement_entity.dart';

class AnnouncementModel extends AnnouncementEntity {
  const AnnouncementModel({
    required super.id,
    required super.title,
    required super.content,
    required super.targetLevel,
    required super.priority,
    required super.createdAt,
    required super.createdBy,
  });

  factory AnnouncementModel.fromMap(Map<String, dynamic> map, String id) {
    return AnnouncementModel(
      id: id,
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      targetLevel: map['targetLevel'] ?? 'all',
      priority: map['priority'] as String? ?? 'normal',
      createdAt: map['createdAt']?.toString() ?? '',
      createdBy: map['createdBy'] as String? ?? 'Équipe FFSC',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'targetLevel': targetLevel,
      'priority': priority,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }
}
