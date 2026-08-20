import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/podium_user_entity.dart';
import '../repositories/podium_repository.dart';

class GetLeaderboardParams extends Equatable {
  final String currentUserId;
  final int currentUserPoints;

  const GetLeaderboardParams({
    required this.currentUserId,
    required this.currentUserPoints,
  });

  @override
  List<Object?> get props => [currentUserId, currentUserPoints];
}

class GetLeaderboardUseCase implements UseCase<LeaderboardData, GetLeaderboardParams> {
  final PodiumRepository repository;

  GetLeaderboardUseCase(this.repository);

  @override
  Future<Either<Failure, LeaderboardData>> call(GetLeaderboardParams params) async {
    return await repository.getLeaderboard(
      currentUserId: params.currentUserId,
      currentUserPoints: params.currentUserPoints,
    );
  }
}
