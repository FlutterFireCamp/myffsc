import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

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
          selectedLabelStyle: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 8.sp,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(AppIcons.dashboard),
              label: "Accueil",
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.programs),
              label: "Cours",
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.announcements),
              label: "Annonces",
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.forms),
              label: "Formulaires",
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.tests),
              label: "Tests",
            ),
            BottomNavigationBarItem(
              icon: Icon(AppIcons.profile),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}
