import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';

enum AnnouncementType {
  info,
  important,
  urgent;

  String get label {
    switch (this) {
      case AnnouncementType.info:
        return 'Information';
      case AnnouncementType.important:
        return 'Flash Info';
      case AnnouncementType.urgent:
        return 'Urgent';
    }
  }

  Widget get icon {
    switch (this) {
      case AnnouncementType.info:
        return AppIcons.infoCircle(color: AppColors.skyBlue, size: 20);
      case AnnouncementType.important:
        return AppIcons.flashInfo(color: AppColors.firebaseYellow, size: 20);
      case AnnouncementType.urgent:
        return AppIcons.alert02(color: AppColors.errorText, size: 20);
    }
  }

  Color get color {
    switch (this) {
      case AnnouncementType.info:
        return AppColors.skyBlue;
      case AnnouncementType.important:
        return AppColors.firebaseYellow;
      case AnnouncementType.urgent:
        return AppColors.errorText;
    }
  }

  static AnnouncementType fromString(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'urgent':
        return AnnouncementType.urgent;
      case 'important':
      case 'flash':
      case 'flash_info':
        return AnnouncementType.important;
      case 'info':
      default:
        return AnnouncementType.info;
    }
  }

  String toDbString() => name;
}

enum TargetRole {
  all,
  student,
  mentor,
  admin;

  String get label {
    switch (this) {
      case TargetRole.all:
        return 'Tous';
      case TargetRole.student:
        return 'Participants';
      case TargetRole.mentor:
        return 'Mentors';
      case TargetRole.admin:
        return 'Administrateurs';
    }
  }

  static TargetRole fromString(String? roleStr) {
    switch (roleStr?.toLowerCase()) {
      case 'student':
        return TargetRole.student;
      case 'mentor':
        return TargetRole.mentor;
      case 'admin':
        return TargetRole.admin;
      case 'all':
      default:
        return TargetRole.all;
    }
  }

  String toDbString() => name;
}

class AnnouncementItem extends Equatable {
  final String id;
  final AnnouncementType type;
  final TargetRole targetRole;
  final String title;
  final String description;
  final String date;
  final DateTime? createdAt;

  const AnnouncementItem({
    required this.id,
    required this.type,
    required this.targetRole,
    required this.title,
    required this.description,
    required this.date,
    this.createdAt,
  });

  factory AnnouncementItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    DateTime? parsedCreatedAt;
    if (data['createdAt'] is Timestamp) {
      parsedCreatedAt = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is String) {
      parsedCreatedAt = DateTime.tryParse(data['createdAt'] as String);
    }

    return AnnouncementItem(
      id: doc.id,
      type: AnnouncementType.fromString(data['type'] as String?),
      targetRole: TargetRole.fromString(data['targetRole'] as String?),
      title: data['title'] as String? ?? 'Sans titre',
      description: data['description'] as String? ?? '',
      date: data['date'] as String? ?? '',
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.toDbString(),
      'targetRole': targetRole.toDbString(),
      'title': title,
      'description': description,
      'date': date,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        type,
        targetRole,
        title,
        description,
        date,
        createdAt,
      ];
}
