import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/announcement_item.dart';
import '../repositories/announcements_repository.dart';

class GetAnnouncementsParams extends Equatable {
  final AnnouncementType? filterType;
  final DocumentSnapshot<Map<String, dynamic>>? startAfterDoc;
  final int limit;

  const GetAnnouncementsParams({
    this.filterType,
    this.startAfterDoc,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [filterType, startAfterDoc, limit];
}

class GetAnnouncementsUseCase
    implements UseCase<PaginatedAnnouncementsResult, GetAnnouncementsParams> {
  final AnnouncementsRepository repository;

  GetAnnouncementsUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedAnnouncementsResult>> call(
      GetAnnouncementsParams params) async {
    return await repository.getAnnouncements(
      filterType: params.filterType,
      startAfterDoc: params.startAfterDoc,
      limit: params.limit,
    );
  }
}
