import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/podium_user_entity.dart';

abstract class PodiumRemoteDataSource {
  Future<LeaderboardData> getLeaderboard({
    required String currentUserId,
    required int currentUserPoints,
  });
}

class PodiumRemoteDataSourceImpl implements PodiumRemoteDataSource {
  final FirebaseFirestore firestore;

  PodiumRemoteDataSourceImpl({required this.firestore});

  @override
  Future<LeaderboardData> getLeaderboard({
    required String currentUserId,
    required int currentUserPoints,
  }) async {
    try {
      dev.log(
        'Récupération du classement (Top 10 + count participants) pour user: $currentUserId ($currentUserPoints pts)',
        name: 'PODIUM_REMOTE_DS',
      );

      // 1. Récupération des utilisateurs pour le classement avec fallback robuste
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      try {
        // Tentative 1 : Requête indexée filtrée par status et triée par points
        querySnapshot = await firestore
            .collection('users')
            .where('status', isEqualTo: 'accepted')
            .orderBy('totalPoints', descending: true)
            .limit(20)
            .get();
      } catch (e, st) {
        dev.log(
          'Requête indexée status+totalPoints a échoué (index composite manquant ?). Tentative fallback 1 (orderBy totalPoints).',
          name: 'PODIUM_REMOTE_DS',
          error: e,
          stackTrace: st,
        );
        try {
          // Tentative 2 : Tri par points uniquement
          querySnapshot = await firestore
              .collection('users')
              .orderBy('totalPoints', descending: true)
              .limit(20)
              .get();
        } catch (e2, st2) {
          dev.log(
            'Fallback 1 a échoué. Tentative fallback 2 (collection brute).',
            name: 'PODIUM_REMOTE_DS',
            error: e2,
            stackTrace: st2,
          );
          // Tentative 3 : Récupération simple de la collection
          querySnapshot = await firestore.collection('users').limit(50).get();
        }
      }

      // Extraction et tri en mémoire pour garantir un classement parfait même sans index Firestore
      final List<Map<String, dynamic>> rawDocs = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).where((d) {
        // Filtrer les étudiants acceptés si possible, sinon garder les rôles 'student'
        final status = d['status'] as String?;
        final role = d['role'] as String?;
        if (status != null && status.isNotEmpty) {
          return status == 'accepted';
        }
        return role == null || role == 'student';
      }).toList();

      rawDocs.sort((a, b) {
        final ptsA = (a['totalPoints'] as num?)?.toInt() ?? 0;
        final ptsB = (b['totalPoints'] as num?)?.toInt() ?? 0;
        if (ptsB != ptsA) {
          return ptsB.compareTo(ptsA);
        }
        final nameA = (a['name'] as String? ?? '').toLowerCase();
        final nameB = (b['name'] as String? ?? '').toLowerCase();
        return nameA.compareTo(nameB);
      });

      final List<PodiumUserEntity> topUsers = [];
      final limitCount = rawDocs.length > 10 ? 10 : rawDocs.length;
      for (int i = 0; i < limitCount; i++) {
        final doc = rawDocs[i];
        final id = doc['id'] as String;
        topUsers.add(PodiumUserEntity.fromFirestore(doc, id, i + 1));
      }

      // 2. Calcul du nombre total de participants via l'agrégation native count()
      int totalParticipants = topUsers.length;
      try {
        final countSnap = await firestore
            .collection('users')
            .where('status', isEqualTo: 'accepted')
            .count()
            .get();
        totalParticipants = countSnap.count ?? topUsers.length;
      } catch (_) {
        try {
          final countSnap = await firestore.collection('users').count().get();
          totalParticipants = countSnap.count ?? topUsers.length;
        } catch (_) {
          totalParticipants = topUsers.length;
        }
      }

      if (totalParticipants < topUsers.length) {
        totalParticipants = topUsers.length;
      }

      // 3. Calcul du rang précis de l'utilisateur connecté
      int userRank = 0;
      PodiumUserEntity? userPodiumData;

      // Vérifier si l'utilisateur est déjà présent dans le Top 10
      final topIndex = topUsers.indexWhere((u) => u.id == currentUserId);
      if (topIndex != -1) {
        userRank = topIndex + 1;
        userPodiumData = topUsers[topIndex];
      } else {
        // S'il est en dehors du Top 10 (ex: 120e), tenter le calcul de son rang exact via count()
        try {
          final higherRankSnap = await firestore
              .collection('users')
              .where('status', isEqualTo: 'accepted')
              .where('totalPoints', isGreaterThan: currentUserPoints)
              .count()
              .get();
          userRank = (higherRankSnap.count ?? 0) + 1;
        } catch (_) {
          try {
            final higherRankSnap = await firestore
                .collection('users')
                .where('totalPoints', isGreaterThan: currentUserPoints)
                .count()
                .get();
            userRank = (higherRankSnap.count ?? 0) + 1;
          } catch (_) {
            userRank = topUsers.length + 1;
          }
        }
      }

      dev.log(
        'Classement chargé: ${topUsers.length} dans Top 10, total: $totalParticipants, userRank: $userRank',
        name: 'PODIUM_REMOTE_DS',
      );

      return LeaderboardData(
        topUsers: topUsers,
        totalParticipants: totalParticipants,
        currentUserRank: userRank > 0 ? userRank : 1,
        currentUserPodiumData: userPodiumData,
      );
    } catch (e, stackTrace) {
      dev.log(
        'Erreur critique lors de la récupération du classement',
        name: 'PODIUM_REMOTE_DS',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
