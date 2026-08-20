import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/announcement_item.dart';

abstract class AnnouncementsRepository {
  Future<Either<Failure, PaginatedAnnouncementsResult>> getAnnouncements({
    AnnouncementType? filterType,
    DocumentSnapshot<Map<String, dynamic>>? startAfterDoc,
    int limit = 10,
  });
}
