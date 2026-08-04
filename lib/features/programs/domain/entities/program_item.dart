import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

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
        return 'Session de cours';
      case ProgramType.conference:
        return 'Conférence';
      case ProgramType.studyGroup:
        return 'Groupe d\'étude';
      case ProgramType.test:
        return 'Test / Évaluation';
    }
  }

  static ProgramType fromString(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'workshop':
        return ProgramType.workshop;
      case 'session':
        return ProgramType.session;
      case 'conference':
        return ProgramType.conference;
      case 'study_group':
      case 'studygroup':
        return ProgramType.studyGroup;
      case 'test':
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
