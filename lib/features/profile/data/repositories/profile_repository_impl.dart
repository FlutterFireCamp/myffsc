import 'dart:developer' as dev;
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../tests/domain/entities/user_question_correction.dart';
import '../../domain/entities/user_test_history_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<Failure, List<UserTestHistoryEntity>>> streamUserTestHistory(
    String userId,
  ) {
    try {
      return remoteDataSource
          .streamUserTestHistory(userId)
          .map<Either<Failure, List<UserTestHistoryEntity>>>(
            (models) => Right(models),
          )
          .handleError((e, st) {
            dev.log('ProfileRepository.streamUserTestHistory failed', name: 'PROFILE_REPO', error: e, stackTrace: st);
            return Left<Failure, List<UserTestHistoryEntity>>(
              ServerFailure(e.toString()),
            );
          });
    } catch (e, st) {
      dev.log('ProfileRepository.streamUserTestHistory catch error', name: 'PROFILE_REPO', error: e, stackTrace: st);
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await remoteDataSource.updateProfile(userId: userId, data: data);
      return const Right(null);
    } catch (e, st) {
      dev.log('ProfileRepository.updateProfile failed', name: 'PROFILE_REPO', error: e, stackTrace: st);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserQuestionCorrection>>> getTestCorrectionDetails({
    required String? quizId,
    required String dateStr,
    required String docId,
    required dynamic rawAnswers,
  }) async {
    try {
      final list = await remoteDataSource.getTestCorrectionDetails(
        quizId: quizId,
        dateStr: dateStr,
        docId: docId,
        rawAnswers: rawAnswers,
      );
      return Right(list);
    } catch (e, st) {
      dev.log('ProfileRepository.getTestCorrectionDetails failed', name: 'PROFILE_REPO', error: e, stackTrace: st);
      return Left(ServerFailure(e.toString()));
    }
  }
}
