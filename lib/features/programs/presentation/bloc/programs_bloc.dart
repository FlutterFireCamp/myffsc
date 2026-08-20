import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/programs_usecases.dart';
import 'programs_event.dart';
import 'programs_state.dart';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  final GetUpcomingProgramsUseCase getUpcomingProgramsUseCase;

  ProgramsBloc({required this.getUpcomingProgramsUseCase})
      : super(ProgramsInitialState()) {
    on<FetchProgramsEvent>(_onFetchPrograms);
    on<FilterProgramsEvent>(_onFilterPrograms);
  }

  Future<void> _onFetchPrograms(
    FetchProgramsEvent event,
    Emitter<ProgramsState> emit,
  ) async {
    try {
      dev.log(
        'Handling FetchProgramsEvent (filter: ${event.filterType?.label}, refresh: ${event.isRefresh})',
        name: 'PROGRAMS_BLOC',
      );

      if (!event.isRefresh && state is! ProgramsLoadedState) {
        emit(ProgramsLoadingState());
      }

      final result = await getUpcomingProgramsUseCase(
        GetUpcomingProgramsParams(filterType: event.filterType),
      );

      result.fold(
        (failure) {
          dev.log('Échec de FetchPrograms: ${failure.message}', name: 'PROGRAMS_BLOC');
          emit(ProgramsErrorState(failure.message));
        },
        (programs) {
          dev.log('${programs.length} programmes chargés avec succès', name: 'PROGRAMS_BLOC');
          emit(ProgramsLoadedState(
            programs: programs,
            currentFilter: event.filterType,
          ));
        },
      );
    } catch (e, stackTrace) {
      dev.log(
        'Exception non gérée dans ProgramsBloc._onFetchPrograms',
        name: 'PROGRAMS_BLOC',
        error: e,
        stackTrace: stackTrace,
      );
      emit(ProgramsErrorState(e.toString()));
    }
  }

  Future<void> _onFilterPrograms(
    FilterProgramsEvent event,
    Emitter<ProgramsState> emit,
  ) async {
    add(FetchProgramsEvent(filterType: event.filterType, isRefresh: true));
  }
}
