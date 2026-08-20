import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../../../tests/domain/entities/user_question_correction.dart';
import '../entities/user_test_history_entity.dart';
import '../repositories/profile_repository.dart';

class StreamProfileTestHistoryUseCase {
  final ProfileRepository repository;

  StreamProfileTestHistoryUseCase(this.repository);

  Stream<Either<Failure, List<UserTestHistoryEntity>>> call(String userId) {
    return repository.streamUserTestHistory(userId);
  }
}

class UpdateProfileParams extends Equatable {
  final String userId;
  final Map<String, dynamic> data;

  const UpdateProfileParams({
    required this.userId,
    required this.data,
  });

  @override
  List<Object?> get props => [userId, data];
}

class UpdateProfileUseCase implements UseCase<void, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      userId: params.userId,
      data: params.data,
    );
  }
}

class GetTestCorrectionDetailsParams extends Equatable {
  final String? quizId;
  final String dateStr;
  final String docId;
  final dynamic rawAnswers;

  const GetTestCorrectionDetailsParams({
    required this.quizId,
    required this.dateStr,
    required this.docId,
    required this.rawAnswers,
  });

  @override
  List<Object?> get props => [quizId, dateStr, docId, rawAnswers];
}

class GetTestCorrectionDetailsUseCase
    implements UseCase<List<UserQuestionCorrection>, GetTestCorrectionDetailsParams> {
  final ProfileRepository repository;

  GetTestCorrectionDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserQuestionCorrection>>> call(
    GetTestCorrectionDetailsParams params,
  ) {
    return repository.getTestCorrectionDetails(
      quizId: params.quizId,
      dateStr: params.dateStr,
      docId: params.docId,
      rawAnswers: params.rawAnswers,
    );
  }
}
