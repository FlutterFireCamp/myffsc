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

  const MainNavigationScaffold({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
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
            tooltip: "Feedback & Avis",
            onPressed: () => FormsModalHelper.openFeedbackForm(context),
            icon: AppIcons.feedback(color: AppColors.ultraDark, size: AppSizes.iconMd),
            color: AppColors.skyBlue,
          ),
          ActionButton(
            tooltip: "Idées & Suggestions",
            onPressed: () => FormsModalHelper.openIdeaForm(context),
            icon: AppIcons.idea(color: AppColors.ultraDark, size: AppSizes.iconMd),
            color: const Color(0xFFFFB703),
          ),
          ActionButton(
            tooltip: "Soumettre Certificat",
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              final userLevel = authState is AuthenticatedState ? authState.user.level : 1;
              FormsModalHelper.openCertificateForm(context, userLevel);
            },
            icon: AppIcons.badge(color: Colors.white, size: AppSizes.iconMd),
            color: const Color(0xFF10B981),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.ultraDark,
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.ultraDark,
          selectedItemColor: AppColors.skyBlue,
          unselectedItemColor: AppColors.textMuted,
          selectedLabelStyle: AppTextStyles.navLabelActive,
          unselectedLabelStyle: AppTextStyles.navLabel,
          items: [
            BottomNavigationBarItem(
              icon: AppIcons.dashboard(color: AppColors.textMuted, size: AppSizes.iconLg),
              activeIcon: AppIcons.dashboard(color: AppColors.skyBlue, size: AppSizes.iconLg),
              label: "Accueil",
            ),
            BottomNavigationBarItem(
              icon: AppIcons.programs(color: AppColors.textMuted, size: AppSizes.iconLg),
              activeIcon: AppIcons.programs(color: AppColors.skyBlue, size: AppSizes.iconLg),
              label: "Cours",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.firebaseYellow.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.firebaseYellow,
                    width: 1.5,
                  ),
                ),
                child: AppIcons.tests(color: AppColors.firebaseYellow, size: AppSizes.iconLg),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.firebaseYellow,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.firebaseYellow,
                    width: 1.5,
                  ),
                ),
                child: AppIcons.tests(color: AppColors.ultraDark, size: AppSizes.iconLg),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: AppIcons.announcements(color: AppColors.textMuted, size: AppSizes.iconLg),
              activeIcon: AppIcons.announcements(color: AppColors.skyBlue, size: AppSizes.iconLg),
              label: "Annonces",
            ),
            BottomNavigationBarItem(
              icon: AppIcons.profile(color: AppColors.textMuted, size: AppSizes.iconLg),
              activeIcon: AppIcons.profile(color: AppColors.skyBlue, size: AppSizes.iconLg),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}
