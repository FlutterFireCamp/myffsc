import 'package:equatable/equatable.dart';
import '../../domain/entities/podium_user_entity.dart';

abstract class PodiumState extends Equatable {
  const PodiumState();

  @override
  List<Object?> get props => [];
}

class PodiumInitialState extends PodiumState {}

class PodiumLoadingState extends PodiumState {}

class PodiumLoadedState extends PodiumState {
  final LeaderboardData data;

  const PodiumLoadedState({required this.data});

  @override
  List<Object?> get props => [data];
}

class PodiumErrorState extends PodiumState {
  final String message;

  const PodiumErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
