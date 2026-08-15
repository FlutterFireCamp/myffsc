import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/core.dart';

enum ProgramType {
  workshop,
  session,
  conference,
  studyGroup,
  test;

  String get label {
    switch (this) {
      case ProgramType.workshop:
        return 'Workshop';
      case ProgramType.session:
        return 'Session';
      case ProgramType.conference:
        return 'Conférence';
      case ProgramType.studyGroup:
        return 'Groupe d\'étude';
      case ProgramType.test:
        return 'Test / Évaluation';
    }
  }

  /// Couleur Principale (Texte & Icônes)
  Color get badgeColor {
    switch (this) {
      case ProgramType.workshop:
        return AppColors.programWorkshopBadge; // #4ADE80
      case ProgramType.session:
        return AppColors.programSessionBadge; // #38BDF8
      case ProgramType.conference:
        return AppColors.programConferenceBadge; // #C084FC
      case ProgramType.test:
        return AppColors.programTestBadge; // #FBBF24
      case ProgramType.studyGroup:
        return AppColors.programWorkshopBadge;
    }
  }

  /// Fond du Badge (Overlay)
  Color get badgeBgColor {
    switch (this) {
      case ProgramType.workshop:
        return AppColors.programWorkshopBadgeBg; // rgba(34, 197, 94, 0.15)
      case ProgramType.session:
        return AppColors.programSessionBadgeBg; // rgba(56, 189, 248, 0.15)
      case ProgramType.conference:
        return AppColors.programConferenceBadgeBg; // rgba(168, 85, 247, 0.15)
      case ProgramType.test:
        return AppColors.programTestBadgeBg; // rgba(251, 191, 36, 0.15)
      case ProgramType.studyGroup:
        return AppColors.programWorkshopBadgeBg;
    }
  }

  /// Bordure du Badge
  Color get borderColor {
    switch (this) {
      case ProgramType.workshop:
        return AppColors.programWorkshopBorder; // rgba(34, 197, 94, 0.30)
      case ProgramType.session:
        return AppColors.programSessionBorder; // rgba(56, 189, 248, 0.30)
      case ProgramType.conference:
        return AppColors.programConferenceBorder; // rgba(168, 85, 247, 0.30)
      case ProgramType.test:
        return AppColors.programTestBorder; // rgba(251, 191, 36, 0.30)
      case ProgramType.studyGroup:
        return AppColors.programWorkshopBorder;
    }
  }

  /// Fond de la Carte (Card Glass)
  Color get cardBgColor {
    switch (this) {
      case ProgramType.workshop:
        return AppColors.programWorkshopBg; // rgba(34, 197, 94, 0.08)
      case ProgramType.session:
        return AppColors.programSessionBg; // rgba(56, 189, 248, 0.08)
      case ProgramType.conference:
        return AppColors.programConferenceBg; // rgba(168, 85, 247, 0.08)
      case ProgramType.test:
        return AppColors.programTestBg; // rgba(245, 158, 11, 0.08)
      case ProgramType.studyGroup:
        return AppColors.programWorkshopBg;
    }
  }

  /// Icône HugeIcons correspondante
  Widget buildIcon({double size = 24.0}) {
    switch (this) {
      case ProgramType.workshop:
        return AppIcons.star(color: badgeColor, size: size); // Star / Code01
      case ProgramType.session:
        return AppIcons.video(color: badgeColor, size: size); // Video01
      case ProgramType.conference:
        return AppIcons.userGroup(color: badgeColor, size: size); // UserGroup
      case ProgramType.test:
        return AppIcons.tests(color: badgeColor, size: size); // Quiz02
      case ProgramType.studyGroup:
        return AppIcons.userGroup(color: badgeColor, size: size);
    }
  }

  static ProgramType fromString(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'workshop':
      case 'atelier':
        return ProgramType.workshop;
      case 'session':
      case 'live':
      case 'cours':
        return ProgramType.session;
      case 'conference':
      case 'conférence':
      case 'talk':
        return ProgramType.conference;
      case 'study_group':
      case 'studygroup':
        return ProgramType.studyGroup;
      case 'test':
      case 'quiz':
      case 'evaluation':
      case 'évaluation':
      case 'examen':
        return ProgramType.test;
      default:
        return ProgramType.session;
    }
  }

  String toDbString() {
    switch (this) {
      case ProgramType.workshop:
        return 'workshop';
      case ProgramType.session:
        return 'session';
      case ProgramType.conference:
        return 'conference';
      case ProgramType.studyGroup:
        return 'study_group';
      case ProgramType.test:
        return 'test';
    }
  }
}

class ProgramItem extends Equatable {
  final String id;
  final ProgramType type;
  final String title;
  final String description;
  final String date;
  final String time;
  final String? sessionUrl;
  final String? replayUrl;
  final String? location;
  final String? speaker;
  final DateTime? createdAt;

  const ProgramItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.sessionUrl,
    this.replayUrl,
    this.location,
    this.speaker,
    this.createdAt,
  });

  /// Formats date to French DD/MM/YYYY style (e.g. 07/08/2026)
  String get formattedFrenchDate {
    if (date.trim().isEmpty) return '';

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

  /// Converts GMT time string stored in DB to user device local time with GMT offset suffix
  String get formattedLocalTime {
    if (time.trim().isEmpty) return '';

    final now = DateTime.now();
    final offset = now.timeZoneOffset;
    final offsetHours = offset.inHours;
    final offsetMinutes = offset.inMinutes.remainder(60).abs();

    final String offsetSign = offset.isNegative ? '-' : '+';
    final String offsetStr = offsetMinutes == 0
        ? 'GMT$offsetSign${offsetHours.abs()}'
        : 'GMT$offsetSign${offsetHours.abs()}:${offsetMinutes.toString().padLeft(2, '0')}';

    final timeParts = time.split(RegExp(r'\s*-\s*|\s+à\s+'));
    List<String> convertedParts = [];

    for (final part in timeParts) {
      final cleanPart = part.trim().replaceAll('h', ':').replaceAll('H', ':');
      final match = RegExp(r'^(\d{1,2})(?::(\d{1,2}))?').firstMatch(cleanPart);
      if (match != null) {
        int hours = int.parse(match.group(1)!);
        int minutes = match.group(2) != null ? int.parse(match.group(2)!) : 0;

        DateTime utcDateTime = DateTime.utc(now.year, now.month, now.day, hours, minutes);
        DateTime localDateTime = utcDateTime.toLocal();

        final formattedHour = localDateTime.hour.toString().padLeft(2, '0');
        final formattedMin = localDateTime.minute.toString().padLeft(2, '0');
        convertedParts.add('${formattedHour}h$formattedMin');
      } else {
        convertedParts.add(part.trim());
      }
    }

    return '${convertedParts.join(' - ')} $offsetStr';
  }

  /// Parses program date & time to DateTime for ordering and past-event filtering
  DateTime? get programDateTime {
    if (date.trim().isEmpty) return createdAt;

    try {
      final isoParsed = DateTime.tryParse(date);
      if (isoParsed != null) return isoParsed;

      final parts = date.split(RegExp(r'[-/.]'));
      if (parts.length == 3) {
        int year, month, day;
        if (parts[0].length == 4) {
          year = int.parse(parts[0]);
          month = int.parse(parts[1]);
          day = int.parse(parts[2]);
        } else {
          day = int.parse(parts[0]);
          month = int.parse(parts[1]);
          year = int.parse(parts[2]);
        }
        return DateTime(year, month, day);
      }
    } catch (_) {}

    return createdAt;
  }

  /// Checks if the program has already passed (before today midnight)
  bool get isPast {
    final dt = programDateTime;
    if (dt == null) return false;
    final todayStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return dt.isBefore(todayStart);
  }

  /// Checks if the program is happening today
  bool get isToday {
    final dt = programDateTime;
    if (dt == null) return false;
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  factory ProgramItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    DateTime? parsedCreatedAt;
    if (data['createdAt'] is Timestamp) {
      parsedCreatedAt = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is String) {
      parsedCreatedAt = DateTime.tryParse(data['createdAt'] as String);
    }

    return ProgramItem(
      id: doc.id,
      type: ProgramType.fromString(data['type'] as String?),
      title: data['title'] as String? ?? 'Sans titre',
      description: data['description'] as String? ?? '',
      date: data['date'] as String? ?? '',
      time: data['time'] as String? ?? '',
      sessionUrl: data['sessionUrl'] as String?,
      replayUrl: data['replayUrl'] as String?,
      location: data['location'] as String?,
      speaker: data['speaker'] as String?,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.toDbString(),
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'sessionUrl': sessionUrl,
      'replayUrl': replayUrl,
      'location': location,
      'speaker': speaker,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        date,
        time,
        sessionUrl,
        replayUrl,
        location,
        speaker,
        createdAt,
      ];
}
