import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/announcement_item.dart';

abstract class AnnouncementsRemoteDataSource {
  Future<PaginatedAnnouncementsResult> getAnnouncements({
    AnnouncementType? filterType,
    DocumentSnapshot<Map<String, dynamic>>? startAfterDoc,
    int limit = 10,
  });
}

class AnnouncementsRemoteDataSourceImpl implements AnnouncementsRemoteDataSource {
  final FirebaseFirestore firestore;

  AnnouncementsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<PaginatedAnnouncementsResult> getAnnouncements({
    AnnouncementType? filterType,
    DocumentSnapshot<Map<String, dynamic>>? startAfterDoc,
    int limit = 10,
  }) async {
    try {
      dev.log(
        'Récupération paginée des annonces (filtre: ${filterType?.label ?? "Toutes"}, limit: $limit, startAfter: ${startAfterDoc?.id})',
        name: 'ANNOUNCEMENTS_REMOTE_DS',
      );

      // Requête sans filtre composite 'where' pour éviter l'obligation d'index composite Firestore (type + createdAt)
      Query<Map<String, dynamic>> query = firestore
          .collection('announcements')
          .orderBy('createdAt', descending: true);

      if (startAfterDoc != null) {
        query = query.startAfterDocument(startAfterDoc);
      }

      query = query.limit(limit);

      final querySnapshot = await query.get();

      var items = querySnapshot.docs
          .map((doc) => AnnouncementItem.fromFirestore(doc))
          .toList();

      if (filterType != null) {
        items = items.where((item) => item.type == filterType).toList();
      }

      final hasMore = querySnapshot.docs.length >= limit;
      final lastDoc = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      dev.log(
        '${items.length} annonce(s) chargée(s), hasMore: $hasMore',
        name: 'ANNOUNCEMENTS_REMOTE_DS',
      );

      return PaginatedAnnouncementsResult(
        items: items,
        lastDocument: lastDoc,
        hasMore: hasMore,
      );
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la récupération paginée des annonces',
        name: 'ANNOUNCEMENTS_REMOTE_DS',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
