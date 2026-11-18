import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../tests/domain/entities/user_question_correction.dart';
import '../entities/user_test_history_entity.dart';

/// Contrat du profil apprenant, des liens sociaux et de l'historique d'évaluation.
abstract class ProfileRepository {
  /// Écoute en continu le flux des évaluations passées par l'apprenant [userId].
  Stream<Either<Failure, List<UserTestHistoryEntity>>> streamUserTestHistory(
    String userId,
  );

  /// Met à jour les informations éditables du profil de l'apprenant [userId].
  Future<Either<Failure, void>> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  });

  /// Récupère la correction détaillée question par question d'un examen passé.
  Future<Either<Failure, List<UserQuestionCorrection>>>
  getTestCorrectionDetails({
    required String? quizId,
    required String dateStr,
    required String docId,
    required dynamic rawAnswers,
  });
}
