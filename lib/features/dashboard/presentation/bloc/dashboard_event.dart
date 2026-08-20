import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchDashboardDataEvent extends DashboardEvent {
  final bool isRefresh;

  const FetchDashboardDataEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}
