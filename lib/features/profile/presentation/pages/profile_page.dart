import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_metrics_card.dart';
import '../widgets/profile_social_links_bar.dart';
import '../widgets/profile_test_history_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _lastUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authState = context.watch<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      if (_lastUserId != authState.user.id) {
        _lastUserId = authState.user.id;
        context.read<ProfileBloc>().add(
          WatchProfileTestHistoryEvent(authState.user.id),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: "Retour",
          icon: AppIcons.chevronLeft(
            color: AppColors.textPrimary,
            size: AppSizes.iconMd,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.dashboard);
            }
          },
        ),
        title: const Text("Profil"),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: "Se déconnecter",
            icon: AppIcons.logout(color: AppColors.errorText, size: 18),
            onPressed: () {
              AppConfirmationDialog.show(
                context,
                title: "Déconnexion",
                message:
                    "Êtes-vous sûr de vouloir vous déconnecter du Portail Apprenant FFSC ?",
                confirmText: "Se déconnecter",
                cancelText: "Annuler",
                isDestructive: true,
                onConfirm: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
              );
            },
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: .symmetric(horizontal: 5.w),
          child: Column(
            spacing: 1.5.h,
            children: [
              // 1. User Header Card (Fixed - Not scrollable)
              ProfileHeaderCard(user: currentUser),

              // 2. Social Links Bar (Fixed - Not scrollable)
              ProfileSocialLinksBar(user: currentUser),

              // 3. Metrics Summary Card (Fixed - Not scrollable)
              ProfileMetricsCard(user: currentUser),
              SizedBox(height: 0.5.h),
              // 4. Test History Section (Scrollable only if content height exceeds container)
              Expanded(child: ProfileTestHistorySection(userId: currentUser.id)),
            ],
          ),
        ),
      ),
    );
  }
}
