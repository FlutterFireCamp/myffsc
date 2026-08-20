import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myffsc/features/podium/podium.dart';

class MockGetLeaderboardUseCase extends Mock implements GetLeaderboardUseCase {}

void main() {
  late MockGetLeaderboardUseCase mockGetLeaderboardUseCase;
  late PodiumBloc podiumBloc;

  setUpAll(() {
    registerFallbackValue(
      const GetLeaderboardParams(currentUserId: 'user_1', currentUserPoints: 100),
    );
  });

  setUp(() {
    mockGetLeaderboardUseCase = MockGetLeaderboardUseCase();
    podiumBloc = PodiumBloc(getLeaderboardUseCase: mockGetLeaderboardUseCase);
  });

  tearDown(() {
    podiumBloc.close();
  });

  const tPodiumUser = PodiumUserEntity(
    id: 'user_1',
    name: 'Champion Flutter',
    totalPoints: 250,
    level: 3,
    rank: 1,
  );

  const tLeaderboardData = LeaderboardData(
    topUsers: [tPodiumUser],
    totalParticipants: 370,
    currentUserRank: 1,
    currentUserPodiumData: tPodiumUser,
  );

  group('PodiumBloc Tests', () {
    blocTest<PodiumBloc, PodiumState>(
      'emits [PodiumLoadingState, PodiumLoadedState] when leaderboard is fetched successfully',
      build: () {
        when(() => mockGetLeaderboardUseCase(any()))
            .thenAnswer((_) async => const Right(tLeaderboardData));
        return podiumBloc;
      },
      act: (bloc) => bloc.add(const FetchLeaderboardEvent(
        currentUserId: 'user_1',
        currentUserPoints: 250,
      )),
      expect: () => [
        isA<PodiumLoadingState>(),
        isA<PodiumLoadedState>().having(
          (s) => s.data.totalParticipants,
          'totalParticipants',
          370,
        ).having(
          (s) => s.data.currentUserRank,
          'currentUserRank',
          1,
        ),
      ],
    );
  });
}
