import 'package:equatable/equatable.dart';
import '../../domain/entities/program_item.dart';

abstract class ProgramsEvent extends Equatable {
  const ProgramsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProgramsEvent extends ProgramsEvent {
  final ProgramType? filterType;
  final bool isRefresh;

  const FetchProgramsEvent({this.filterType, this.isRefresh = false});

  @override
  List<Object?> get props => [filterType, isRefresh];
}

class FilterProgramsEvent extends ProgramsEvent {
  final ProgramType? filterType;

  const FilterProgramsEvent(this.filterType);

  @override
  List<Object?> get props => [filterType];
}
