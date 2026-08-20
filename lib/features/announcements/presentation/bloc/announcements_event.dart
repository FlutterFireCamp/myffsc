import 'package:equatable/equatable.dart';
import '../../domain/entities/announcement_item.dart';

abstract class AnnouncementsEvent extends Equatable {
  const AnnouncementsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAnnouncementsEvent extends AnnouncementsEvent {
  final AnnouncementType? filterType;
  final bool isRefresh;

  const FetchAnnouncementsEvent({this.filterType, this.isRefresh = false});

  @override
  List<Object?> get props => [filterType, isRefresh];
}

class LoadMoreAnnouncementsEvent extends AnnouncementsEvent {
  const LoadMoreAnnouncementsEvent();
}

class FilterAnnouncementsEvent extends AnnouncementsEvent {
  final AnnouncementType? filterType;

  const FilterAnnouncementsEvent(this.filterType);

  @override
  List<Object?> get props => [filterType];
}
