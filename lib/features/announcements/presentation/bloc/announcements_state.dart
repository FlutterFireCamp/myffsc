import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/announcement_item.dart';

abstract class AnnouncementsState extends Equatable {
  const AnnouncementsState();

  @override
  List<Object?> get props => [];
}

class AnnouncementsInitialState extends AnnouncementsState {}

class AnnouncementsLoadingState extends AnnouncementsState {}

class AnnouncementsLoadedState extends AnnouncementsState {
  final List<AnnouncementItem> announcements;
  final bool hasMore;
  final bool isLoadingMore;
  final AnnouncementType? currentFilter;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;

  const AnnouncementsLoadedState({
    required this.announcements,
    required this.hasMore,
    this.isLoadingMore = false,
    this.currentFilter,
    this.lastDocument,
  });

  AnnouncementsLoadedState copyWith({
    List<AnnouncementItem>? announcements,
    bool? hasMore,
    bool? isLoadingMore,
    AnnouncementType? currentFilter,
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
  }) {
    return AnnouncementsLoadedState(
      announcements: announcements ?? this.announcements,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentFilter: currentFilter ?? this.currentFilter,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }

  @override
  List<Object?> get props => [
        announcements,
        hasMore,
        isLoadingMore,
        currentFilter,
        lastDocument,
      ];
}

class AnnouncementsErrorState extends AnnouncementsState {
  final String message;

  const AnnouncementsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
