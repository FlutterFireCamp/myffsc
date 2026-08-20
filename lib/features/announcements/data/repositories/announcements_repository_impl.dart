import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/announcement_item.dart';
import '../../domain/repositories/announcements_repository.dart';
import '../datasources/announcements_remote_data_source.dart';

class AnnouncementsRepositoryImpl implements AnnouncementsRepository {
  final AnnouncementsRemoteDataSource remoteDataSource;

  AnnouncementsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedAnnouncementsResult>> getAnnouncements({
    AnnouncementType? filterType,
    DocumentSnapshot<Map<String, dynamic>>? startAfterDoc,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getAnnouncements(
        filterType: filterType,
        startAfterDoc: startAfterDoc,
        limit: limit,
      );
      return Right(result);
    } catch (e, stackTrace) {
      dev.log(
        'Erreur dans AnnouncementsRepositoryImpl.getAnnouncements',
        name: 'ANNOUNCEMENTS_REPO',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure("Impossible de charger les annonces : ${e.toString()}"));
    }
  }
}
