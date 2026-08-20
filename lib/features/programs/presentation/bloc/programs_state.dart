import 'package:equatable/equatable.dart';
import '../../domain/entities/program_item.dart';

abstract class ProgramsState extends Equatable {
  const ProgramsState();

  @override
  List<Object?> get props => [];
}

class ProgramsInitialState extends ProgramsState {}

class ProgramsLoadingState extends ProgramsState {}

class ProgramsLoadedState extends ProgramsState {
  final List<ProgramItem> programs;
  final ProgramType? currentFilter;

  const ProgramsLoadedState({
    required this.programs,
    this.currentFilter,
  });

  @override
  List<Object?> get props => [programs, currentFilter];
}

class ProgramsErrorState extends ProgramsState {
  final String message;

  const ProgramsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
