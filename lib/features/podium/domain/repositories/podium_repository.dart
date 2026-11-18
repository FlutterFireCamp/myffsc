import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/podium_user_entity.dart';

/// Contrat du classement général et du podium du camp.
///
/// Charge les scores, les rangs des apprenants, le Top 3 et la position
/// relative de l'utilisateur connecté.
abstract class PodiumRepository {
  /// Récupère l'état complet du classement (Top 3, Top 10 et position relative).
  ///
  /// - [currentUserId] : identifiant de l'apprenant connecté.
  /// - [currentUserPoints] : points actuels pour déterminer son rang instantané.
  Future<Either<Failure, LeaderboardData>> getLeaderboard({
    required String currentUserId,
    required int currentUserPoints,
  });
}
