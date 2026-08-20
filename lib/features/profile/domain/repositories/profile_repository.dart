import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../tests/domain/entities/user_question_correction.dart';
import '../entities/user_test_history_entity.dart';

abstract class ProfileRepository {
  Stream<Either<Failure, List<UserTestHistoryEntity>>> streamUserTestHistory(
    String userId,
  );

  Future<Either<Failure, void>> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, List<UserQuestionCorrection>>> getTestCorrectionDetails({
    required String? quizId,
    required String dateStr,
    required String docId,
    required dynamic rawAnswers,
  });
}
