import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/podium_usecases.dart';
import 'podium_event.dart';
import 'podium_state.dart';

class PodiumBloc extends Bloc<PodiumEvent, PodiumState> {
  final GetLeaderboardUseCase getLeaderboardUseCase;

  PodiumBloc({required this.getLeaderboardUseCase})
      : super(PodiumInitialState()) {
    on<FetchLeaderboardEvent>(_onFetchLeaderboard);
  }

  Future<void> _onFetchLeaderboard(
    FetchLeaderboardEvent event,
    Emitter<PodiumState> emit,
  ) async {
    try {
      dev.log(
        'Handling FetchLeaderboardEvent (userId: ${event.currentUserId}, refresh: ${event.isRefresh})',
        name: 'PODIUM_BLOC',
      );

      if (!event.isRefresh && state is! PodiumLoadedState) {
        emit(PodiumLoadingState());
      }

      final result = await getLeaderboardUseCase(
        GetLeaderboardParams(
          currentUserId: event.currentUserId,
          currentUserPoints: event.currentUserPoints,
        ),
      );

      result.fold(
        (failure) {
          dev.log('Échec de FetchLeaderboard: ${failure.message}', name: 'PODIUM_BLOC');
          emit(PodiumErrorState(failure.message));
        },
        (data) {
          dev.log(
            'Leaderboard chargé avec succès: ${data.topUsers.length} users, total: ${data.totalParticipants}, userRank: ${data.currentUserRank}',
            name: 'PODIUM_BLOC',
          );
          emit(PodiumLoadedState(data: data));
        },
      );
    } catch (e, stackTrace) {
      dev.log(
        'Exception non gérée dans PodiumBloc._onFetchLeaderboard',
        name: 'PODIUM_BLOC',
        error: e,
        stackTrace: stackTrace,
      );
      emit(PodiumErrorState(e.toString()));
    }
  }
}
