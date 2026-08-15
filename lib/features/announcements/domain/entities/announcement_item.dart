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

  /// Icône HugeIcons exacte
  Widget get icon {
    switch (this) {
      case AnnouncementType.info:
        return AppIcons.infoCircle(
          color: color,
          size: 20,
        ); // strokeRoundedInformationCircle
      case AnnouncementType.important:
        return AppIcons.flashInfo(color: color, size: 20); // strokeRoundedFlash
      case AnnouncementType.urgent:
        return AppIcons.alert02(
          color: color,
          size: 20,
        ); // strokeRoundedInformationDiamond
    }
  }

  /// Couleur Principale (Texte & Icônes)
  Color get color {
    switch (this) {
      case AnnouncementType.info:
        return AppColors.announcementInfoColor; // #38BDF8 (Bleu Cyan)
      case AnnouncementType.important:
        return AppColors
            .announcementImportantColor; // #FBBF24 (Jaune Amber Warm)
      case AnnouncementType.urgent:
        return AppColors.announcementUrgentColor; // #F87171 (Rouge Corail)
    }
  }

  /// Fond du Badge (Overlay)
  Color get badgeBgColor {
    switch (this) {
      case AnnouncementType.info:
        return AppColors.announcementInfoBadgeBg; // rgba(56, 189, 248, 0.12)
      case AnnouncementType.important:
        return AppColors
            .announcementImportantBadgeBg; // rgba(245, 158, 11, 0.12)
      case AnnouncementType.urgent:
        return AppColors.announcementUrgentBadgeBg; // rgba(239, 68, 68, 0.12)
    }
  }

  /// Bordure du Badge
  Color get borderColor {
    switch (this) {
      case AnnouncementType.info:
        return AppColors.announcementInfoBorder; // rgba(56, 189, 248, 0.30)
      case AnnouncementType.important:
        return AppColors
            .announcementImportantBorder; // rgba(245, 158, 11, 0.30)
      case AnnouncementType.urgent:
        return AppColors.announcementUrgentBorder; // rgba(239, 68, 68, 0.30)
    }
  }

  /// Fond de la Carte (Card Glass)
  Color get cardBgColor {
    switch (this) {
      case AnnouncementType.info:
        return AppColors.announcementInfoCardBg; // rgba(56, 189, 248, 0.06)
      case AnnouncementType.important:
        return AppColors
            .announcementImportantCardBg; // rgba(245, 158, 11, 0.06)
      case AnnouncementType.urgent:
        return AppColors.announcementUrgentCardBg; // rgba(239, 68, 68, 0.06)
    }
  }

  static AnnouncementType fromString(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'urgent':
      case 'urgente':
        return AnnouncementType.urgent;
      case 'important':
      case 'flash':
      case 'flash_info':
      case 'flashinfo':
        return AnnouncementType.important;
      case 'info':
      case 'information':
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

  /// Formats date to French DD/MM/YYYY style (e.g. 07/08/2026)
  String get formattedFrenchDate {
    if (date.trim().isEmpty) return 'Date non précisée';

    try {
      final dt = DateTime.tryParse(date);
      if (dt != null) {
        final day = dt.day.toString().padLeft(2, '0');
        final month = dt.month.toString().padLeft(2, '0');
        return '$day/$month/${dt.year}';
      }

      final parts = date.split(RegExp(r'[-/.]'));
      if (parts.length == 3 && parts[0].length == 4) {
        return '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
      }
    } catch (_) {}

    return date;
  }

  factory AnnouncementItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
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
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
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
