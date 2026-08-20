import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/podium_user_entity.dart';

abstract class PodiumRepository {
  Future<Either<Failure, LeaderboardData>> getLeaderboard({
    required String currentUserId,
    required int currentUserPoints,
  });
}
