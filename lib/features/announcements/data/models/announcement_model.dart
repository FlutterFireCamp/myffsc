import '../../domain/entities/announcement_item.dart';

class AnnouncementModel extends AnnouncementItem {
  const AnnouncementModel({
    required super.id,
    required super.type,
    required super.targetRole,
    required super.title,
    required super.description,
    required super.date,
    super.createdAt,
  });

  factory AnnouncementModel.fromMap(Map<String, dynamic> map, String id) {
    return AnnouncementModel(
      id: id,
      type: AnnouncementType.fromString(map['type'] as String?),
      targetRole: TargetRole.fromString(map['targetRole'] as String?),
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      date: map['date'] as String? ?? '',
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) : null,
    );
  }
}
