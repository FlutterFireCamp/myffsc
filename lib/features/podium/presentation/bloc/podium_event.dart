import 'package:equatable/equatable.dart';

abstract class PodiumEvent extends Equatable {
  const PodiumEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeaderboardEvent extends PodiumEvent {
  final String currentUserId;
  final int currentUserPoints;
  final bool isRefresh;

  const FetchLeaderboardEvent({
    required this.currentUserId,
    required this.currentUserPoints,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [currentUserId, currentUserPoints, isRefresh];
}
