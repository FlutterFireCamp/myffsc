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



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      floatingActionButton: StreamBuilder<bool>(
        stream: sl<CampConfigService>().isCampEndedStream,
        initialData: sl<CampConfigService>().isCampEnded,
        builder: (context, snapshot) {
          final isCampEnded = snapshot.data ?? false;
          final authState = context.watch<AuthBloc>().state;
          final currentUser =
              authState is AuthenticatedState ? authState.user : null;
          final userLevel = currentUser?.level ?? 1;

          if (isCampEnded) {
            // Une fois la fin du camp arrivée, le bouton renvoie directement
            // sur la vérification du certificat de l'apprenant (plus de vue des liens de formulaires).
            return FloatingActionButton(
              heroTag: 'certificate_verification_fab',
              onPressed: () {
                FormsModalHelper.openCertificateVerification(
                  context,
                  user: currentUser,
                );
              },
              backgroundColor: AppColors.skyBlue,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              tooltip: currentUser?.hasCertificate == true
                  ? "Vérifier mon certificat"
                  : "Portail de vérification",
              child: AppIcons.certificate(color: Colors.white, size: AppSizes.iconLg),
            );
          }

          // Pendant le camp actif : ExpandableFab avec les formulaires
          return ExpandableFab(
            distance: 112,
            children: [
              ActionButton(
                tooltip: "Signalements",
                onPressed: () => FormsModalHelper.openReportForm(context),
                icon: AppIcons.alert02(
                    color: Colors.white, size: AppSizes.iconMd),
                color: AppColors.errorText,
              ),
              ActionButton(
                tooltip: "Sessions & Ateliers",
                onPressed: () => FormsModalHelper.openFeedbackForm(context),
                icon: AppIcons.feedback(
                    color: Colors.white, size: AppSizes.iconMd),
                color: AppColors.skyBlue,
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
                  FormsModalHelper.openCertificateForm(context, userLevel);
                },
                icon: AppIcons.certificate(
                    color: Colors.white, size: AppSizes.iconMd),
                color: AppColors.certificateGreen,
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.ultraDark,
            selectedItemColor: AppColors.skyBlue,
            unselectedItemColor: AppColors.textMuted,
            selectedLabelStyle: AppTextStyles.navLabelActive.copyWith(
              color: AppColors.skyBlue,
            ),
            unselectedLabelStyle: AppTextStyles.navLabel,
            items: [
              BottomNavigationBarItem(
                icon: AppIcons.dashboard(
                  color: AppColors.textMuted,
                  size: AppSizes.iconLg,
                ),
                activeIcon: AppIcons.dashboard(
                  color: AppColors.skyBlue,
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
                  color: AppColors.skyBlue,
                  size: AppSizes.iconLg,
                ),
                label: "Évaluation",
              ),
              BottomNavigationBarItem(
                icon: AppIcons.programs(
                  color: AppColors.textMuted,
                  size: AppSizes.iconLg,
                ),
                activeIcon: AppIcons.programs(
                  color: AppColors.skyBlue,
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
                  color: AppColors.skyBlue,
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
                  color: AppColors.skyBlue,
                  size: AppSizes.iconLg,
                ),
                label: "Podium",
              ),

            ],
          ),
        ),
      ),
      ),
    );
  }
}
