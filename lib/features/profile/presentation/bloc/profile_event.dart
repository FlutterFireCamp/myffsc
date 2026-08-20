import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class WatchProfileTestHistoryEvent extends ProfileEvent {
  final String userId;

  const WatchProfileTestHistoryEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateProfileSubmittedEvent extends ProfileEvent {
  final String userId;
  final Map<String, dynamic> data;

  const UpdateProfileSubmittedEvent({
    required this.userId,
    required this.data,
  });

  @override
  List<Object?> get props => [userId, data];
}

class FetchTestCorrectionDetailsEvent extends ProfileEvent {
  final String? quizId;
  final String dateStr;
  final String docId;
  final dynamic rawAnswers;

  const FetchTestCorrectionDetailsEvent({
    required this.quizId,
    required this.dateStr,
    required this.docId,
    required this.rawAnswers,
  });

  @override
  List<Object?> get props => [quizId, dateStr, docId, rawAnswers];
}
