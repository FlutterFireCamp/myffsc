import 'package:equatable/equatable.dart';
import 'question_item_entity.dart';

class TestQuizEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final int totalDurationMinutes;
  final int totalPoints;
  final List<QuestionItemEntity> questions;
  final DateTime? availabilityStartGmt;
  final DateTime? availabilityEndGmt;
  final String status; // 'active' | 'upcoming' | 'completed'

  const TestQuizEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.totalDurationMinutes,
    required this.totalPoints,
    required this.questions,
    this.availabilityStartGmt,
    this.availabilityEndGmt,
    this.status = 'active',
  });

  /// Dynamically calculated total points based on questions (never defaults to 500)
  int get calculatedTotalPoints {
    if (totalPoints > 0 && totalPoints != 500) return totalPoints;
    if (questions.isNotEmpty) {
      return questions.fold<int>(0, (sum, q) => sum + q.actualPoints);
    }
    return 100;
  }

  /// Converts GMT availability to user's local phone time string
  String get localAvailabilityRangeText {
    // Default GMT window: 12:00 GMT to 14:00 GMT if not explicitly provided
    final startGmt = availabilityStartGmt ??
        DateTime.utc(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          12,
          0,
        );

    final endGmt = availabilityEndGmt ??
        DateTime.utc(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          14,
          0,
        );

    final localStart = startGmt.toLocal();
    final localEnd = endGmt.toLocal();

    final startStr =
        "${localStart.hour.toString().padLeft(2, '0')}:${localStart.minute.toString().padLeft(2, '0')}";
    final endStr =
        "${localEnd.hour.toString().padLeft(2, '0')}:${localEnd.minute.toString().padLeft(2, '0')}";

    final offsetHours = localStart.timeZoneOffset.inHours;
    final sign = offsetHours >= 0 ? '+' : '';
    final tzLabel = "UTC$sign$offsetHours";

    return "$startStr - $endStr ($tzLabel • Heure locale)";
  }

  /// Estimated average time per question
  String get avgTimePerQuestionText {
    if (questions.isEmpty) return "~1 min / question";
    final totalSec = totalDurationMinutes * 60;
    final avgSec = totalSec ~/ questions.length;
    if (avgSec >= 60) {
      final mins = (avgSec / 60).toStringAsFixed(1);
      return "~$mins min / question";
    } else {
      return "~$avgSec sec / question";
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        totalDurationMinutes,
        totalPoints,
        questions,
        availabilityStartGmt,
        availabilityEndGmt,
        status,
      ];
}
