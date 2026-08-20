import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/announcements_usecases.dart';
import 'announcements_event.dart';
import 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;

  AnnouncementsBloc({required this.getAnnouncementsUseCase})
      : super(AnnouncementsInitialState()) {
    on<FetchAnnouncementsEvent>(_onFetchAnnouncements);
    on<LoadMoreAnnouncementsEvent>(_onLoadMoreAnnouncements);
    on<FilterAnnouncementsEvent>(_onFilterAnnouncements);
  }

  Future<void> _onFetchAnnouncements(
    FetchAnnouncementsEvent event,
    Emitter<AnnouncementsState> emit,
  ) async {
    try {
      dev.log(
        'Handling FetchAnnouncementsEvent (filter: ${event.filterType?.label}, refresh: ${event.isRefresh})',
        name: 'ANNOUNCEMENTS_BLOC',
      );

      if (!event.isRefresh && state is! AnnouncementsLoadedState) {
        emit(AnnouncementsLoadingState());
      }

      final result = await getAnnouncementsUseCase(
        GetAnnouncementsParams(
          filterType: event.filterType,
          limit: 10,
        ),
      );

      result.fold(
        (failure) {
          dev.log('Échec de FetchAnnouncements: ${failure.message}', name: 'ANNOUNCEMENTS_BLOC');
          emit(AnnouncementsErrorState(failure.message));
        },
        (data) {
          dev.log('${data.items.length} annonce(s) chargée(s), hasMore: ${data.hasMore}', name: 'ANNOUNCEMENTS_BLOC');
          emit(AnnouncementsLoadedState(
            announcements: data.items,
            hasMore: data.hasMore,
            lastDocument: data.lastDocument,
            currentFilter: event.filterType,
          ));
        },
      );
    } catch (e, stackTrace) {
      dev.log(
        'Exception non gérée dans AnnouncementsBloc._onFetchAnnouncements',
        name: 'ANNOUNCEMENTS_BLOC',
        error: e,
        stackTrace: stackTrace,
      );
      emit(AnnouncementsErrorState(e.toString()));
    }
  }

  Future<void> _onLoadMoreAnnouncements(
    LoadMoreAnnouncementsEvent event,
    Emitter<AnnouncementsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AnnouncementsLoadedState) return;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    try {
      dev.log(
        'Chargement du lot suivant d’annonces (cursor: ${currentState.lastDocument?.id})',
        name: 'ANNOUNCEMENTS_BLOC',
      );

      emit(currentState.copyWith(isLoadingMore: true));

      final result = await getAnnouncementsUseCase(
        GetAnnouncementsParams(
          filterType: currentState.currentFilter,
          startAfterDoc: currentState.lastDocument,
          limit: 10,
        ),
      );

      result.fold(
        (failure) {
          dev.log('Échec de LoadMoreAnnouncements: ${failure.message}', name: 'ANNOUNCEMENTS_BLOC');
          emit(currentState.copyWith(isLoadingMore: false));
        },
        (data) {
          final updatedList = List.of(currentState.announcements)..addAll(data.items);
          dev.log('Total cumulé d’annonces: ${updatedList.length}, hasMore: ${data.hasMore}', name: 'ANNOUNCEMENTS_BLOC');
          emit(currentState.copyWith(
            announcements: updatedList,
            hasMore: data.hasMore,
            lastDocument: data.lastDocument,
            isLoadingMore: false,
          ));
        },
      );
    } catch (e, stackTrace) {
      dev.log(
        'Exception non gérée dans AnnouncementsBloc._onLoadMoreAnnouncements',
        name: 'ANNOUNCEMENTS_BLOC',
        error: e,
        stackTrace: stackTrace,
      );
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onFilterAnnouncements(
    FilterAnnouncementsEvent event,
    Emitter<AnnouncementsState> emit,
  ) async {
    add(FetchAnnouncementsEvent(filterType: event.filterType, isRefresh: true));
  }
}
