import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/auth.dart';

class ProfilePage extends StatelessWidget {
  final UserEntity? user;

  const ProfilePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = user ?? (authState is AuthenticatedState ? authState.user : null);

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
        title: const Text("Profil Apprenant 👤"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            // User Avatar Card
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.flutterBlue,
                    backgroundImage: currentUser.photoUrl != null ? NetworkImage(currentUser.photoUrl!) : null,
                    child: currentUser.photoUrl == null
                        ? Text(
                            currentUser.firstName.isNotEmpty ? currentUser.firstName[0].toUpperCase() : 'A',
                            style: TextStyle(fontSize: 24.sp, color: Colors.white, fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    currentUser.name,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    currentUser.email,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 10.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                    decoration: BoxDecoration(
                      color: AppColors.correctContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.correctBorder),
                    ),
                    child: Text(
                      "Statut : ${currentUser.status.toUpperCase()} • Apprenant FFSC 💙☀️",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.correctText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),

            // Metrics Summary Card
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MetricItem(
                    title: "Niveau",
                    value: "Niveau ${currentUser.level}",
                    icon: AppIcons.badge,
                    color: AppColors.skyBlue,
                  ),
                  Container(width: 1, height: 40, color: AppColors.borderSubtle),
                  _MetricItem(
                    title: "Points FFSC",
                    value: "${currentUser.totalPoints} pts",
                    icon: AppIcons.star,
                    color: AppColors.firebaseYellow,
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Profile Options
            _ProfileTile(
              icon: AppIcons.profile,
              title: "Informations personnelles",
              subtitle: "Consulter les données de votre compte",
              onTap: () {},
            ),
            SizedBox(height: 1.5.h),
            _ProfileTile(
              icon: AppIcons.badge,
              title: "Badges & Certifications",
              subtitle: "Voir les badges obtenus pendant le camp",
              onTap: () {},
            ),
            SizedBox(height: 1.5.h),
            _ProfileTile(
              icon: AppIcons.info,
              title: "À propos de FlutterFire Summer Camp",
              subtitle: "Immersion 3 mois & Mentorat Tech Afrique",
              onTap: () {},
            ),
            SizedBox(height: 4.h),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.errorText),
                  padding: EdgeInsets.symmetric(vertical: 1.8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(AppIcons.logout, color: AppColors.errorText, size: 18),
                label: Text(
                  "Déconnexion",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.errorText,
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 0.8.h),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 0.3.h),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 9.sp,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.skyBlue),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 9.sp,
            color: AppColors.textMuted,
          ),
        ),
        trailing: const Icon(AppIcons.arrowRight, color: AppColors.textMuted, size: 16),
      ),
    );
  }
}
