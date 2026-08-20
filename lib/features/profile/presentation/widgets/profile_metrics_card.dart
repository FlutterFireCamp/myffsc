import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../podium/presentation/bloc/podium_bloc.dart';
import '../../../podium/presentation/bloc/podium_event.dart';
import '../../../podium/presentation/bloc/podium_state.dart';

class ProfileMetricsCard extends StatefulWidget {
  final UserEntity user;

  const ProfileMetricsCard({super.key, required this.user});

  @override
  State<ProfileMetricsCard> createState() => _ProfileMetricsCardState();
}

class _ProfileMetricsCardState extends State<ProfileMetricsCard> {
  @override
  void initState() {
    super.initState();
    final podiumBloc = context.read<PodiumBloc>();
    if (podiumBloc.state is PodiumInitialState) {
      podiumBloc.add(
        FetchLeaderboardEvent(
          currentUserId: widget.user.id,
          currentUserPoints: widget.user.totalPoints,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final podiumState = context.watch<PodiumBloc>().state;

    String rankDisplay = "-";
    if (podiumState is PodiumLoadedState) {
      final rank = podiumState.data.currentUserRank;
      final total = podiumState.data.totalParticipants;
      final suffix = rank == 1 ? "er" : "e";
      rankDisplay = "$rank$suffix / $total";
    } else if (podiumState is PodiumLoadingState) {
      rankDisplay = "...";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          Expanded(
            child: _MetricItem(
              title: "Niveau",
              value: "Niveau ${widget.user.level}",
              icon: AppIcons.badge(
                color: AppColors.getLevelColor(widget.user.level),
                size: AppSizes.iconLg,
              ),
            ),
          ),
          Container(width: 1, height: 35, color: AppColors.borderSubtle),
          Expanded(
            child: _MetricItem(
              title: "Points",
              value: "${widget.user.totalPoints} pts",
              icon: AppIcons.star(
                color: AppColors.gold,
                size: AppSizes.iconLg,
              ),
            ),
          ),
          Container(width: 1, height: 35, color: AppColors.borderSubtle),
          Expanded(
            child: _MetricItem(
              title: "Classement",
              value: rankDisplay,
              icon: AppIcons.ranking(
                color: AppColors.correctText,
                size: AppSizes.iconLg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      spacing: 0.4.h,
      children: [
        icon,
        FittedBox(
          fit: .scaleDown,
          child: Text(value, style: AppTextStyles.metricValue),
        ),
        Text(title, style: AppTextStyles.metricLabel),
      ],
    );
  }
}
