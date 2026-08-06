import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../programs/domain/entities/program_item.dart';
import '../widgets/dashboard_header_banner.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/today_program_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ProgramItem? _todayProgram;
  bool _isLoadingTodayProgram = true;

  @override
  void initState() {
    super.initState();
    _fetchTodayProgram();
  }

  Future<void> _fetchTodayProgram() async {
    try {
      final querySnapshot = await _firestore.collection('programs').get();

      if (querySnapshot.docs.isNotEmpty) {
        final activePrograms = querySnapshot.docs
            .map((doc) => ProgramItem.fromFirestore(doc))
            .where((item) => !item.isPast)
            .toList();

        activePrograms.sort((a, b) {
          final dtA = a.programDateTime;
          final dtB = b.programDateTime;
          if (dtA == null && dtB == null) return 0;
          if (dtA == null) return 1;
          if (dtB == null) return -1;
          return dtA.compareTo(dtB);
        });

        if (activePrograms.isNotEmpty) {
          setState(() {
            _todayProgram = activePrograms.first;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching today program: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTodayProgram = false;
        });
      }
    }
  }

  Future<void> _launchExternalUrl(String? urlString) async {
    if (urlString == null || urlString.trim().isEmpty) return;
    final Uri url = Uri.parse(
      urlString.startsWith('http') ? urlString : 'https://$urlString',
    );
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Impossible d'ouvrir le lien : $urlString"),
              backgroundColor: AppColors.incorrectContainer,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'ouverture : $e"),
            backgroundColor: AppColors.incorrectContainer,
          ),
        );
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
          children: [
            AppCachedAvatar(
              imageUrl: currentUser.photoUrl,
              radius: 20,
              fallbackInitial: currentUser.firstName,
              fallbackTextStyle: AppTextStyles.titleMedium,
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              children: [
                AppIcons.star(size: 18, color: AppColors.firebaseYellow),
                SizedBox(width: 1.w),
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
          // Header Level Progress Banner
          DashboardHeaderBanner(
            userLevel: currentUser.level,
            totalPoints: currentUser.totalPoints,
            onActionTap: handlePrograms,
          ),
          SizedBox(height: 2.h),

          // Programme du jour ou à venir
          Text(
            (_todayProgram != null && _todayProgram!.isToday)
                ? "Programme du jour"
                : "Programme à venir",
            style: AppTextStyles.titleLarge,
          ),
          SizedBox(height: 1.h),
          _isLoadingTodayProgram
              ? const AppShimmer(child: AppCardShimmer())
              : _todayProgram == null
              ? const AppEmptyState(
                  title: "Aucun programme prévu aujourd'hui",
                  message:
                      "Consultez l'onglet Programmes pour découvrir les prochaines sessions.",
                )
              : TodayProgramCard(
                  program: _todayProgram!,
                  onLaunchUrl: _launchExternalUrl,
                ),
          SizedBox(height: 2.h),

          // Quick Actions Grid
          Text("Aujourd'hui dans le Camp", style: AppTextStyles.titleLarge),
          SizedBox(height: 1.h),
          Row(
            spacing: 3.w,
            children: [
              Expanded(
                child: QuickActionCard(
                  title: "Programmes",
                  subtitle: "Syllabus complet & cours",
                  icon: AppIcons.programs(
                    color: AppColors.actionBlue,
                    size: AppSizes.iconLg,
                  ),
                  backgroundColor: AppColors.actionBlue,
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
