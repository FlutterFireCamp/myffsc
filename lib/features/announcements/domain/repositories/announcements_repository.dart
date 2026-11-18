import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/announcement_item.dart';

/// Contrat du flux d'annonces et d'actualités du FlutterFire Summer Camp.
///
/// Permet la pagination et le filtrage par type d'annonce (Info, Flash, Urgence).
abstract class AnnouncementsRepository {
  /// Récupère une page d'annonces depuis Firestore.
  ///
  /// - [filterType] : filtre optionnel par catégorie.
  /// - [startAfterDoc] : curseur de pagination Firestore.
  /// - [limit] : nombre d'annonces à charger (par défaut 10).
  Future<Either<Failure, PaginatedAnnouncementsResult>> getAnnouncements({
    AnnouncementType? filterType,
    DocumentSnapshot<Map<String, dynamic>>? startAfterDoc,
    int limit = 10,
  });
}
