import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../forms/presentation/widgets/action_button.dart';
import '../../../forms/presentation/widgets/expandable_fab.dart';
import '../../../forms/presentation/widgets/forms_modal_helper.dart';

class MainNavigationScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationScaffold({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _buildProfileTabIcon(BuildContext context, bool isActive) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;
    final photoUrl = currentUser?.photoUrl;
    final initial = currentUser?.firstName ?? 'A';

    if (photoUrl != null && photoUrl.trim().isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          shape: .circle,
          border: Border.all(
            color: isActive
                ? AppColors.actionBlue
                : AppColors.textMuted.withValues(alpha: 0.3),
            width: isActive ? 2.0 : 1.0,
          ),
        ),
        child: AppCachedAvatar(
          imageUrl: photoUrl,
          radius: 11,
          fallbackInitial: initial,
        ),
      );
    }

    return AppIcons.profile(
      color: isActive ? AppColors.actionBlue : AppColors.textMuted,
      size: AppSizes.iconLg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            tooltip: "Signalements",
            onPressed: () => FormsModalHelper.openReportForm(context),
            icon: AppIcons.alert02(color: Colors.white, size: AppSizes.iconMd),
            color: AppColors.errorText,
          ),
          ActionButton(
            tooltip: "Sessions & Ateliers",
            onPressed: () => FormsModalHelper.openFeedbackForm(context),
            icon: AppIcons.feedback(color: Colors.white, size: AppSizes.iconMd),
            color: AppColors.actionBlue,
          ),
          ActionButton(
            tooltip: "Idées & Suggestions",
            onPressed: () => FormsModalHelper.openIdeaForm(context),
            icon: AppIcons.idea(
              color: AppColors.ultraDark,
              size: AppSizes.iconMd,
            ),
            color: AppColors.ideaAmber,
          ),
          ActionButton(
            tooltip: "Soumettre Certificat",
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              final userLevel = authState is AuthenticatedState
                  ? authState.user.level
                  : 1;
              FormsModalHelper.openCertificateForm(context, userLevel);
            },
            icon: AppIcons.badge(color: Colors.white, size: AppSizes.iconMd),
            color: AppColors.certificateGreen,
          ),
        ],
      ),
      floatingActionButtonLocation: .endFloat,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.ultraDark,
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 1),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
            type: .fixed,
            backgroundColor: AppColors.ultraDark,
            selectedItemColor: AppColors.actionBlue,
            unselectedItemColor: AppColors.textMuted,
            selectedLabelStyle: AppTextStyles.navLabelActive.copyWith(
              color: AppColors.actionBlue,
            ),
            unselectedLabelStyle: AppTextStyles.navLabel,
            items: [
              BottomNavigationBarItem(
                icon: AppIcons.dashboard(
                  color: AppColors.textMuted,
                  size: AppSizes.iconLg,
                ),
                activeIcon: AppIcons.dashboard(
                  color: AppColors.actionBlue,
                  size: AppSizes.iconLg,
                ),
                label: "Accueil",
              ),
              BottomNavigationBarItem(
                icon: AppIcons.tests(
                  color: AppColors.textMuted,
                  size: AppSizes.iconLg,
                ),
                activeIcon: AppIcons.tests(
                  color: AppColors.actionBlue,
                  size: AppSizes.iconLg,
                ),
                label: "Tests",
              ),
              BottomNavigationBarItem(
                icon: AppIcons.programs(
                  color: AppColors.textMuted,
                  size: AppSizes.iconLg,
                ),
                activeIcon: AppIcons.programs(
                  color: AppColors.actionBlue,
                  size: AppSizes.iconLg,
                ),
                label: "Agenda",
              ),
              BottomNavigationBarItem(
                icon: AppIcons.announcements(
                  color: AppColors.textMuted,
                  size: AppSizes.iconLg,
                ),
                activeIcon: AppIcons.announcements(
                  color: AppColors.actionBlue,
                  size: AppSizes.iconLg,
                ),
                label: "Annonces",
              ),
              BottomNavigationBarItem(
                icon: AppIcons.podium(
                  color: AppColors.textMuted,
                  size: AppSizes.iconLg,
                ),
                activeIcon: AppIcons.podium(
                  color: AppColors.actionBlue,
                  size: AppSizes.iconLg,
                ),
                label: "Podium",
              ),
              BottomNavigationBarItem(
                icon: _buildProfileTabIcon(context, false),
                activeIcon: _buildProfileTabIcon(context, true),
                label: "Profil",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
