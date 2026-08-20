import 'package:equatable/equatable.dart';
import '../../../tests/domain/entities/user_question_correction.dart';
import '../../domain/entities/user_test_history_entity.dart';

enum ProfileUpdateStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final bool isLoadingHistory;
  final List<UserTestHistoryEntity> testHistory;
  final String? historyError;

  final ProfileUpdateStatus updateStatus;
  final String? updateError;

  final bool isLoadingCorrection;
  final List<UserQuestionCorrection> correctionDetails;
  final String? correctionError;

  const ProfileState({
    this.isLoadingHistory = true,
    this.testHistory = const [],
    this.historyError,
    this.updateStatus = ProfileUpdateStatus.initial,
    this.updateError,
    this.isLoadingCorrection = false,
    this.correctionDetails = const [],
    this.correctionError,
  });

  ProfileState copyWith({
    bool? isLoadingHistory,
    List<UserTestHistoryEntity>? testHistory,
    String? historyError,
    ProfileUpdateStatus? updateStatus,
    String? updateError,
    bool? isLoadingCorrection,
    List<UserQuestionCorrection>? correctionDetails,
    String? correctionError,
  }) {
    return ProfileState(
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      testHistory: testHistory ?? this.testHistory,
      historyError: historyError,
      updateStatus: updateStatus ?? this.updateStatus,
      updateError: updateError,
      isLoadingCorrection: isLoadingCorrection ?? this.isLoadingCorrection,
      correctionDetails: correctionDetails ?? this.correctionDetails,
      correctionError: correctionError,
    );
  }

  @override
  List<Object?> get props => [
        isLoadingHistory,
        testHistory,
        historyError,
        updateStatus,
        updateError,
        isLoadingCorrection,
        correctionDetails,
        correctionError,
      ];
}
