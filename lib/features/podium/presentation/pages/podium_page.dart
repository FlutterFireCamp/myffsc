import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/podium_user_entity.dart';
import '../widgets/current_user_rank_card.dart';
import '../widgets/leaderboard_user_row.dart';
import '../widgets/top_three_podium.dart';

class PodiumPage extends StatefulWidget {
  const PodiumPage({super.key});

  @override
  State<PodiumPage> createState() => _PodiumPageState();
}

class _PodiumPageState extends State<PodiumPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<PodiumUserEntity> _allUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final querySnapshot = await _firestore.collection('users').get();

      final List<Map<String, dynamic>> rawDocs = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).where((data) {
        final status = data['status'] as String?;
        final role = data['role'] as String?;
        // Include accepted students or normal valid users
        return status == null || status == 'accepted' || role == 'student';
      }).toList();

      // Sort by totalPoints descending, then by name ascending
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

      final List<PodiumUserEntity> sortedUsers = [];
      for (int i = 0; i < rawDocs.length; i++) {
        final doc = rawDocs[i];
        final id = doc['id'] as String;
        sortedUsers.add(PodiumUserEntity.fromFirestore(doc, id, i + 1));
      }

      if (mounted) {
        setState(() {
          _allUsers = sortedUsers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Impossible de charger le classement : $e";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;

    final topThree = _allUsers.take(3).toList();
    final remainingUsers = _allUsers.skip(3).toList();

    int currentUserRank = 0;
    PodiumUserEntity? currentUserPodiumData;

    if (currentUser != null) {
      final foundIndex = _allUsers.indexWhere((u) => u.id == currentUser.id);
      if (foundIndex != -1) {
        currentUserRank = foundIndex + 1;
        currentUserPodiumData = _allUsers[foundIndex];
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Classement Général",
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: "Actualiser",
            icon: AppIcons.refresh03(color: AppColors.skyBlue, size: 20),
            onPressed: _fetchLeaderboard,
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? ListView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                children: const [
                  AppShimmer(child: AppCardShimmer()),
                  SizedBox(height: 16),
                  AppShimmer(child: AppCardShimmer()),
                  SizedBox(height: 16),
                  AppShimmer(child: AppCardShimmer()),
                ],
              )
            : _errorMessage != null
                ? AppEmptyState(
                    title: "Erreur de chargement",
                    message: _errorMessage!,
                    icon: AppIcons.warning(color: AppColors.alertRed, size: AppSizes.iconXl),
                    accentColor: AppColors.alertRed,
                    actionLabel: "Réessayer",
                    onAction: _fetchLeaderboard,
                  )
                : _allUsers.isEmpty
                    ? AppEmptyState(
                        title: "Aucun classement disponible",
                        message: "Les participants apparaîtront ici dès que les points seront enregistrés.",
                        icon: AppIcons.podium(color: AppColors.skyBlue, size: AppSizes.iconXl),
                        accentColor: AppColors.skyBlue,
                        actionLabel: "Actualiser",
                        onAction: _fetchLeaderboard,
                      )
                    : Stack(
                        children: [
                          RefreshIndicator(
                            color: AppColors.skyBlue,
                            onRefresh: _fetchLeaderboard,
                            child: ListView(
                              padding: EdgeInsets.only(
                                left: 5.w,
                                right: 5.w,
                                top: 1.h,
                                bottom: currentUserPodiumData != null ? 14.h : 4.h,
                              ),
                              children: [
                                // Top 3 Podium Card
                                if (topThree.isNotEmpty) ...[
                                  TopThreePodium(topThree: topThree),
                                  SizedBox(height: 3.h),
                                ],

                                // Top 10 Section Header
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Top 10 (Places 4 à 10)",
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${_allUsers.length} inscrits",
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.5.h),

                                // Remaining Users Rows
                                ...remainingUsers.map((user) {
                                  final isMe = currentUser != null && user.id == currentUser.id;
                                  return LeaderboardUserRow(
                                    user: user,
                                    isCurrentUser: isMe,
                                  );
                                }),
                              ],
                            ),
                          ),

                          // Current User Rank Sticky Card Footer
                          if (currentUser != null)
                            Positioned(
                              bottom: 1.5.h,
                              left: 4.w,
                              right: 4.w,
                              child: CurrentUserRankCard(
                                userRank: currentUserRank > 0 ? currentUserRank : 1,
                                totalParticipants: _allUsers.length,
                                totalPoints: currentUserPodiumData?.totalPoints ?? currentUser.totalPoints,
                                level: currentUserPodiumData?.level ?? currentUser.level,
                              ),
                            ),
                        ],
                      ),
      ),
    );
  }
}
