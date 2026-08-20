import 'package:equatable/equatable.dart';
import '../../../programs/domain/entities/program_item.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitialState extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardLoadedState extends DashboardState {
  final ProgramItem? todayProgram;

  const DashboardLoadedState({this.todayProgram});

  @override
  List<Object?> get props => [todayProgram];
}

class DashboardErrorState extends DashboardState {
  final String message;

  const DashboardErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
