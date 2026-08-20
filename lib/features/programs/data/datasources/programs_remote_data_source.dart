import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/program_item.dart';

abstract class ProgramsRemoteDataSource {
  Future<List<ProgramItem>> getUpcomingPrograms({ProgramType? filterType});
  Future<ProgramItem?> getTodayOrNextProgram();
}

class ProgramsRemoteDataSourceImpl implements ProgramsRemoteDataSource {
  final FirebaseFirestore firestore;

  ProgramsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ProgramItem>> getUpcomingPrograms({ProgramType? filterType}) async {
    try {
      dev.log(
        'Récupération des programmes avec filtre: ${filterType?.label ?? "Tous"}',
        name: 'PROGRAMS_REMOTE_DS',
      );

      Query<Map<String, dynamic>> query = firestore.collection('programs');

      if (filterType != null) {
        query = query.where('type', isEqualTo: filterType.toDbString());
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        dev.log('Aucun document trouvé dans /programs', name: 'PROGRAMS_REMOTE_DS');
        return [];
      }

      final items = querySnapshot.docs
          .map((doc) => ProgramItem.fromFirestore(doc))
          .where((item) => !item.isPast)
          .toList();

      // Tri croissant : la session la plus proche à venir en premier
      items.sort((a, b) {
        final dtA = a.programDateTime;
        final dtB = b.programDateTime;
        if (dtA == null && dtB == null) return 0;
        if (dtA == null) return 1;
        if (dtB == null) return -1;
        return dtA.compareTo(dtB);
      });

      dev.log(
        '${items.length} programme(s) actif(s) récupéré(s)',
        name: 'PROGRAMS_REMOTE_DS',
      );

      return items;
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la récupération des programmes',
        name: 'PROGRAMS_REMOTE_DS',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<ProgramItem?> getTodayOrNextProgram() async {
    try {
      dev.log(
        'Recherche optimisée du programme du jour ou prochain live...',
        name: 'PROGRAMS_REMOTE_DS',
      );

      // 1. Récupération des programmes actifs
      final querySnapshot = await firestore
          .collection('programs')
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final activePrograms = querySnapshot.docs
          .map((doc) => ProgramItem.fromFirestore(doc))
          .where((item) => !item.isPast)
          .toList();

      if (activePrograms.isEmpty) return null;

      activePrograms.sort((a, b) {
        final dtA = a.programDateTime;
        final dtB = b.programDateTime;
        if (dtA == null && dtB == null) return 0;
        if (dtA == null) return 1;
        if (dtB == null) return -1;
        return dtA.compareTo(dtB);
      });

      final nextProgram = activePrograms.first;
      dev.log(
        'Prochain programme trouvé: ${nextProgram.title} (${nextProgram.formattedLocalTime})',
        name: 'PROGRAMS_REMOTE_DS',
      );

      return nextProgram;
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la récupération du prochain programme pour le Dashboard',
        name: 'PROGRAMS_REMOTE_DS',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
