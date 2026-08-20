import 'dart:developer' as dev;
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/podium_user_entity.dart';
import '../../domain/repositories/podium_repository.dart';
import '../datasources/podium_remote_data_source.dart';

class PodiumRepositoryImpl implements PodiumRepository {
  final PodiumRemoteDataSource remoteDataSource;

  PodiumRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LeaderboardData>> getLeaderboard({
    required String currentUserId,
    required int currentUserPoints,
  }) async {
    try {
      final result = await remoteDataSource.getLeaderboard(
        currentUserId: currentUserId,
        currentUserPoints: currentUserPoints,
      );
      return Right(result);
    } catch (e, stackTrace) {
      dev.log(
        'Erreur dans PodiumRepositoryImpl.getLeaderboard',
        name: 'PODIUM_REPO',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure("Impossible de charger le classement : ${e.toString()}"));
    }
  }
}
