import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/program_item.dart';
import '../../domain/usecases/programs_usecases.dart';
import 'programs_event.dart';
import 'programs_state.dart';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  final GetUpcomingProgramsUseCase getUpcomingProgramsUseCase;
  List<ProgramItem> _allPrograms = [];

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

      // Toujours émettre l'état de chargement (shimmer) pour un feedback visuel immédiat
      emit(ProgramsLoadingState());

      final result = await getUpcomingProgramsUseCase(
        const GetUpcomingProgramsParams(filterType: null),
      );

      result.fold(
        (failure) {
          dev.log('Échec de FetchPrograms: ${failure.message}', name: 'PROGRAMS_BLOC');
          emit(ProgramsErrorState(failure.message));
        },
        (programs) {
          _allPrograms = programs;
          final filtered = event.filterType == null
              ? _allPrograms
              : _allPrograms.where((p) => p.type == event.filterType).toList();

          dev.log('${filtered.length} programmes chargés avec succès (filtre: ${event.filterType?.label ?? "Tous"})', name: 'PROGRAMS_BLOC');
          emit(ProgramsLoadedState(
            programs: filtered,
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
    if (_allPrograms.isNotEmpty) {
      emit(ProgramsLoadingState());
      await Future<void>.delayed(const Duration(milliseconds: 120));
      final filtered = event.filterType == null
          ? _allPrograms
          : _allPrograms.where((p) => p.type == event.filterType).toList();
      emit(ProgramsLoadedState(
        programs: filtered,
        currentFilter: event.filterType,
      ));
    } else {
      emit(ProgramsLoadingState());
      add(FetchProgramsEvent(filterType: event.filterType, isRefresh: true));
    }
  }
}
