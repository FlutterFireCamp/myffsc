import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/dashboard_header_banner.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/today_program_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Rafraîchissement unique à l'ouverture de l'application
    context.read<DashboardBloc>().add(const FetchDashboardDataEvent());
  }

  Future<void> _launchExternalUrl(String? urlString) async {
    if (urlString == null || urlString.trim().isEmpty) return;
    final Uri url = Uri.parse(
      urlString.startsWith('http') ? urlString : 'https://$urlString',
    );
    try {
      if (!await launchUrl(url, mode: .externalApplication)) {
        if (mounted) {
          AppSnackBar.showError(
            context,
            "Impossible d'ouvrir le lien : $urlString",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, "Erreur lors de l'ouverture : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;

    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.skyBlue),
        ),
      );
    }

    void handlePrograms() => context.go('/programs');
    void handleAnnouncements() => context.go('/announcements');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          spacing: 3.w,
          children: [
            AppCachedAvatar(
              imageUrl: currentUser.photoUrl,
              radius: 20,
              fallbackInitial: currentUser.firstName,
              fallbackTextStyle: AppTextStyles.titleMedium,
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "Salut, ${currentUser.firstName} 👋🏾",
                  style: AppTextStyles.h3,
                ),
                Text("Apprenant FFSC 💙☀️", style: AppTextStyles.bodySmall),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
            decoration: BoxDecoration(
              color: AppColors.firebaseYellow.withValues(alpha: 0.15),
              borderRadius: AppRadius.circular12,
              border: Border.all(color: AppColors.firebaseYellow, width: 1),
            ),
            child: Row(
              spacing: 1.w,
              children: [
                const Text("🏆"),
                Text(
                  "${currentUser.totalPoints} pts",
                  style: AppTextStyles.badge.copyWith(
                    color: AppColors.firebaseYellow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
          // 1. Header Level Progress Banner
          DashboardHeaderBanner(
            userLevel: currentUser.level,
            totalPoints: currentUser.totalPoints,
            onActionTap: handlePrograms,
          ),
          SizedBox(height: 2.5.h),

          // 2. Programme du jour ou à venir (BlocBuilder ciblé)
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoadingState ||
                  state is DashboardInitialState) {
                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppShimmer(
                      child: AppShimmerBox(
                        width: 45.w,
                        height: 2.2.h,
                        borderRadius: AppRadius.circular6,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const AppCardShimmer(),
                  ],
                );
              }

              final todayProgram = state is DashboardLoadedState
                  ? state.todayProgram
                  : null;

              return Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    (todayProgram != null && todayProgram.isToday)
                        ? "Programme du jour"
                        : "Programme à venir",
                    style: AppTextStyles.titleLarge,
                  ),
                  SizedBox(height: 1.h),
                  todayProgram == null
                      ? const AppEmptyState(
                          title: "Aucun programme prévu aujourd'hui",
                          message:
                              "Consultez l'onglet Programmes pour découvrir les prochaines sessions.",
                        )
                      : TodayProgramCard(
                          program: todayProgram,
                          onLaunchUrl: _launchExternalUrl,
                        ),
                ],
              );
            },
          ),
          SizedBox(height: 2.5.h),

          // 3. Quick Actions Header & 2 Cards (Programmes & Annonces)
          Text("Aujourd'hui dans le Camp", style: AppTextStyles.titleLarge),
          SizedBox(height: 1.h),
          Row(
            spacing: 3.w,
            children: [
              Expanded(
                child: QuickActionCard(
                  title: "Programmes",
                  subtitle: "Agenda complet",
                  icon: AppIcons.programs(
                    color: AppColors.skyBlue,
                    size: AppSizes.iconLg,
                  ),
                  backgroundColor: AppColors.skyBlue,
                  onTap: handlePrograms,
                ),
              ),
              Expanded(
                child: QuickActionCard(
                  title: "Annonces",
                  subtitle: "Fil d'actualité",
                  icon: AppIcons.announcements(
                    color: AppColors.skyBlue,
                    size: AppSizes.iconLg,
                  ),
                  backgroundColor: AppColors.skyBlue,
                  onTap: handleAnnouncements,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
