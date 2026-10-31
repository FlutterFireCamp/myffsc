import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/announcement_item.dart';
import '../../domain/usecases/announcements_usecases.dart';
import 'announcements_event.dart';
import 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;
  List<AnnouncementItem> _allAnnouncements = [];

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

      // Toujours émettre l'état de chargement (shimmer) pour un feedback visuel immédiat
      emit(AnnouncementsLoadingState());

      final result = await getAnnouncementsUseCase(
        const GetAnnouncementsParams(
          filterType: null,
          limit: 30,
        ),
      );

      result.fold(
        (failure) {
          dev.log('Échec de FetchAnnouncements: ${failure.message}', name: 'ANNOUNCEMENTS_BLOC');
          emit(AnnouncementsErrorState(failure.message));
        },
        (data) {
          _allAnnouncements = data.items;
          final filtered = event.filterType == null
              ? _allAnnouncements
              : _allAnnouncements.where((a) => a.type == event.filterType).toList();

          dev.log('${filtered.length} annonce(s) affichée(s) sur ${_allAnnouncements.length}, hasMore: ${data.hasMore}', name: 'ANNOUNCEMENTS_BLOC');
          emit(AnnouncementsLoadedState(
            announcements: filtered,
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
          filterType: null,
          limit: 20,
          startAfterDoc: currentState.lastDocument,
        ),
      );

      result.fold(
        (failure) {
          dev.log('Échec de LoadMoreAnnouncements: ${failure.message}', name: 'ANNOUNCEMENTS_BLOC');
          emit(currentState.copyWith(isLoadingMore: false));
        },
        (data) {
          _allAnnouncements.addAll(data.items);
          final currentFilter = currentState.currentFilter;
          final filtered = currentFilter == null
              ? _allAnnouncements
              : _allAnnouncements.where((a) => a.type == currentFilter).toList();

          dev.log('Total cumulé d’annonces: ${_allAnnouncements.length}, hasMore: ${data.hasMore}', name: 'ANNOUNCEMENTS_BLOC');
          emit(currentState.copyWith(
            announcements: filtered,
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
    final currentState = state;
    if (_allAnnouncements.isNotEmpty) {
      emit(AnnouncementsLoadingState());
      await Future<void>.delayed(const Duration(milliseconds: 120));
      final filtered = event.filterType == null
          ? _allAnnouncements
          : _allAnnouncements.where((a) => a.type == event.filterType).toList();
      if (currentState is AnnouncementsLoadedState) {
        emit(currentState.copyWith(
          announcements: filtered,
          currentFilter: event.filterType,
        ));
      } else {
        emit(AnnouncementsLoadedState(
          announcements: filtered,
          hasMore: false,
          currentFilter: event.filterType,
        ));
      }
    } else {
      emit(AnnouncementsLoadingState());
      add(FetchAnnouncementsEvent(filterType: event.filterType, isRefresh: true));
    }
  }
}
