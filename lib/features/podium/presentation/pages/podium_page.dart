import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/podium_bloc.dart';
import '../bloc/podium_event.dart';
import '../bloc/podium_state.dart';
import '../widgets/current_user_rank_card.dart';
import '../widgets/leaderboard_user_row.dart';
import '../widgets/podium_rules_dialog.dart';
import '../widgets/podium_shimmer.dart';
import '../widgets/top_three_podium.dart';

class PodiumPage extends StatefulWidget {
  const PodiumPage({super.key});

  @override
  State<PodiumPage> createState() => _PodiumPageState();
}

class _PodiumPageState extends State<PodiumPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLeaderboard();
    });
  }

  void _fetchLeaderboard({bool isRefresh = false}) {
    final authState = context.read<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;
    if (currentUser != null) {
      context.read<PodiumBloc>().add(
        FetchLeaderboardEvent(
          currentUserId: currentUser.id,
          currentUserPoints: currentUser.totalPoints,
          isRefresh: isRefresh,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatedState) {
              final podiumState = context.read<PodiumBloc>().state;
              if (podiumState is PodiumInitialState ||
                  podiumState is PodiumErrorState) {
                _fetchLeaderboard();
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            "Classement Général",
            style: AppTextStyles.h3.copyWith(fontWeight: .bold),
          ),
          backgroundColor: AppColors.background,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: "Règles du Classement",
              icon: AppIcons.infoCircle(color: AppColors.skyBlue, size: 20),
              onPressed: () => PodiumRulesDialog.show(context),
            ),
            IconButton(
              tooltip: "Actualiser",
              icon: AppIcons.refresh03(color: AppColors.skyBlue, size: 20),
              onPressed: () => _fetchLeaderboard(isRefresh: true),
            ),
            SizedBox(width: 2.w),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<PodiumBloc, PodiumState>(
            builder: (context, state) {
              if (state is PodiumLoadingState || state is PodiumInitialState) {
                return const PodiumShimmer();
              }

              if (state is PodiumErrorState) {
                return AppEmptyState(
                  title: "Erreur de chargement",
                  message: state.message,
                  icon: AppIcons.warning(
                    color: AppColors.alertRed,
                    size: AppSizes.iconXl,
                  ),
                  accentColor: AppColors.alertRed,
                  actionLabel: "Réessayer",
                  onAction: () => _fetchLeaderboard(isRefresh: true),
                );
              }

              if (state is PodiumLoadedState) {
                final data = state.data;
                final allUsers = data.topUsers;
                final topThree = allUsers.take(3).toList();
                final remainingUsers = allUsers.skip(3).toList();

                if (allUsers.isEmpty) {
                  return AppEmptyState(
                    title: "Aucun classement disponible",
                    message:
                        "Les participants apparaîtront ici dès que les points seront enregistrés.",
                    icon: AppIcons.podium(
                      color: AppColors.skyBlue,
                      size: AppSizes.iconXl,
                    ),
                    accentColor: AppColors.skyBlue,
                    actionLabel: "Actualiser",
                    onAction: () => _fetchLeaderboard(isRefresh: true),
                  );
                }

                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Top 3 Podium Card (Fixed - Not scrollable)
                        if (topThree.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
                            child: TopThreePodium(topThree: topThree),
                          ),
                        SizedBox(height: 1.5.h),

                        // 2. Top 10 Section Header (Fixed - Not scrollable)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Top 10 (Places 4 à 10)",
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${data.totalParticipants} participants",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1.h),

                        // 3. Scrollable List of Ranks 4 to 10 Only (Refresh via AppBar Action)
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              left: 5.w,
                              right: 5.w,
                              top: 0.5.h,
                              bottom: currentUser != null ? 10.h : 4.h,
                            ),
                            itemCount: remainingUsers.length,
                            itemBuilder: (context, index) {
                              final user = remainingUsers[index];
                              final isMe =
                                  currentUser != null &&
                                  user.id == currentUser.id;
                              return LeaderboardUserRow(
                                user: user,
                                isCurrentUser: isMe,
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    // Current User Rank Sticky Card Footer
                    if (currentUser != null)
                      Positioned(
                        bottom: 1.5.h,
                        left: 4.w,
                        right: 4.w,
                        child: CurrentUserRankCard(
                          userRank: data.currentUserRank,
                          totalParticipants: data.totalParticipants,
                          totalPoints:
                              data.currentUserPodiumData?.totalPoints ??
                              currentUser.totalPoints,
                          level:
                              data.currentUserPodiumData?.level ??
                              currentUser.level,
                        ),
                      ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
