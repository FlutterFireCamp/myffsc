import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../../programs/domain/usecases/programs_usecases.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetTodayOrNextProgramUseCase getTodayOrNextProgramUseCase;

  DashboardBloc({required this.getTodayOrNextProgramUseCase})
      : super(DashboardInitialState()) {
    on<FetchDashboardDataEvent>(_onFetchDashboardData);
  }

  Future<void> _onFetchDashboardData(
    FetchDashboardDataEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      dev.log(
        'Handling FetchDashboardDataEvent (refresh: ${event.isRefresh})',
        name: 'DASHBOARD_BLOC',
      );

      if (!event.isRefresh && state is! DashboardLoadedState) {
        emit(DashboardLoadingState());
      }

      final result = await getTodayOrNextProgramUseCase(NoParams());

      result.fold(
        (failure) {
          dev.log('Échec de FetchDashboardData: ${failure.message}', name: 'DASHBOARD_BLOC');
          emit(DashboardErrorState(failure.message));
        },
        (todayProgram) {
          dev.log(
            'Dashboard program chargé: ${todayProgram?.title ?? "Aucun programme"}',
            name: 'DASHBOARD_BLOC',
          );
          emit(DashboardLoadedState(todayProgram: todayProgram));
        },
      );
    } catch (e, stackTrace) {
      dev.log(
        'Exception non gérée dans DashboardBloc._onFetchDashboardData',
        name: 'DASHBOARD_BLOC',
        error: e,
        stackTrace: stackTrace,
      );
      emit(DashboardErrorState(e.toString()));
    }
  }
}
