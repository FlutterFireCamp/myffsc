import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/edit_profile_bottom_sheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _launchExternalUrl(BuildContext context, String? urlString) async {
    if (urlString == null || urlString.trim().isEmpty) return;
    final Uri url = Uri.parse(urlString.startsWith('http') ? urlString : 'https://$urlString');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Impossible d'ouvrir le lien : $urlString"),
              backgroundColor: AppColors.incorrectContainer,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
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

    final locationText = [
      if (currentUser.town != null && currentUser.town!.isNotEmpty) currentUser.town,
      if (currentUser.country != null && currentUser.country!.isNotEmpty) currentUser.country,
    ].join(', ');

    final hubText = currentUser.hub ?? currentUser.community;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Profil Apprenant"),
      ),
      body: ListView(
        primary: false,
        padding: EdgeInsets.all(5.w),
        children: [
          SizedBox(height: 1.h),

          // User Card Header with Edit Button at Bottom Right
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular20,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppCachedAvatar(
                      imageUrl: currentUser.photoUrl,
                      radius: 40,
                      fallbackInitial: currentUser.firstName,
                      fallbackTextStyle: AppTextStyles.h1.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 1.5.h),
                    Text(
                      currentUser.name,
                      style: AppTextStyles.h3,
                      textAlign: TextAlign.center,
                    ),

                    // Headline / Spécialité
                    if (currentUser.headline != null && currentUser.headline!.isNotEmpty) ...[
                      SizedBox(height: 0.4.h),
                      Text(
                        currentUser.headline!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.skyBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    SizedBox(height: 0.4.h),
                    Text(
                      currentUser.email,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),

                    // Location / Hub info
                    if (locationText.isNotEmpty || (hubText != null && hubText.isNotEmpty)) ...[
                      SizedBox(height: 1.2.h),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 2.w,
                        runSpacing: 0.8.h,
                        children: [
                          if (locationText.isNotEmpty)
                            _buildBadgeChip(
                              icon: Icons.location_on_outlined,
                              text: locationText,
                            ),
                          if (hubText != null && hubText.isNotEmpty)
                            _buildBadgeChip(
                              icon: Icons.groups_outlined,
                              text: hubText,
                            ),
                        ],
                      ),
                    ],

                    // Bio
                    if (currentUser.bio != null && currentUser.bio!.isNotEmpty) ...[
                      SizedBox(height: 1.5.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppColors.ultraDark.withValues(alpha: 0.5),
                          borderRadius: AppRadius.circular12,
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Text(
                          currentUser.bio!,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),

                // Pencil Edit Icon Button in Bottom Right
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => EditProfileBottomSheet.show(context, currentUser),
                    borderRadius: AppRadius.circular12,
                    child: Container(
                      padding: EdgeInsets.all(2.5.w),
                      decoration: BoxDecoration(
                        color: AppColors.actionBlue.withValues(alpha: 0.15),
                        borderRadius: AppRadius.circular12,
                        border: Border.all(color: AppColors.actionBlue.withValues(alpha: 0.3)),
                      ),
                      child: AppIcons.edit(color: AppColors.skyBlue, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Social Links Bar (If any social link exists)
          if (_hasSocialLinks(currentUser)) ...[
            Text(
              "Réseaux & Liens",
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 1.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (currentUser.github != null && currentUser.github!.isNotEmpty)
                  _buildSocialIconButton(
                    icon: AppIcons.github(color: Colors.white, size: 20),
                    tooltip: "GitHub",
                    onTap: () => _launchExternalUrl(context, currentUser.github),
                  ),
                if (currentUser.linkedin != null && currentUser.linkedin!.isNotEmpty)
                  _buildSocialIconButton(
                    icon: AppIcons.linkedin(color: const Color(0xFF0A66C2), size: 20),
                    tooltip: "LinkedIn",
                    onTap: () => _launchExternalUrl(context, currentUser.linkedin),
                  ),
                if (currentUser.x != null && currentUser.x!.isNotEmpty)
                  _buildSocialIconButton(
                    icon: AppIcons.twitter(color: Colors.white, size: 20),
                    tooltip: "X / Twitter",
                    onTap: () => _launchExternalUrl(context, currentUser.x),
                  ),
                if (currentUser.portfolio != null && currentUser.portfolio!.isNotEmpty)
                  _buildSocialIconButton(
                    icon: AppIcons.link(color: AppColors.skyBlue, size: 20),
                    tooltip: "Portfolio",
                    onTap: () => _launchExternalUrl(context, currentUser.portfolio),
                  ),
              ],
            ),
            SizedBox(height: 3.h),
          ],

          // Metrics Summary Card
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular16,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricItem(
                  title: "Niveau",
                  value: "Niveau ${currentUser.level}",
                  icon: AppIcons.badge(color: AppColors.skyBlue, size: AppSizes.iconLg),
                ),
                Container(width: 1, height: 40, color: AppColors.borderSubtle),
                _MetricItem(
                  title: "Points FFSC",
                  value: "${currentUser.totalPoints} pts",
                  icon: AppIcons.star(color: AppColors.firebaseYellow, size: AppSizes.iconLg),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Profile Options Tiles
          _ProfileTile(
            icon: AppIcons.edit(color: AppColors.skyBlue, size: AppSizes.iconMd),
            title: "Modifier mon Profil",
            subtitle: "Changer vos coordonnées, bio et réseaux sociaux",
            onTap: () => EditProfileBottomSheet.show(context, currentUser),
          ),
          SizedBox(height: 1.5.h),
          _ProfileTile(
            icon: AppIcons.announcements(color: AppColors.skyBlue, size: AppSizes.iconMd),
            title: "Notifications & Rappels",
            subtitle: "Gérer les alertes des cours et lives",
            onTap: () {},
          ),
          SizedBox(height: 1.5.h),
          _ProfileTile(
            icon: AppIcons.logout(color: AppColors.errorText, size: AppSizes.iconMd),
            title: "Déconnexion",
            subtitle: "Se déconnecter du compte Google",
            isDestructive: true,
            onTap: () {
              AppConfirmationDialog.show(
                context,
                title: "Déconnexion",
                message: "Êtes-vous sûr de vouloir vous déconnecter du Portail Apprenant FFSC ?",
                confirmText: "Se déconnecter",
                cancelText: "Annuler",
                isDestructive: true,
                onConfirm: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
              );
            },
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  bool _hasSocialLinks(UserEntity user) {
    return (user.github != null && user.github!.isNotEmpty) ||
        (user.linkedin != null && user.linkedin!.isNotEmpty) ||
        (user.x != null && user.x!.isNotEmpty) ||
        (user.portfolio != null && user.portfolio!.isNotEmpty);
  }

  Widget _buildBadgeChip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppColors.actionBlue.withValues(alpha: 0.12),
        borderRadius: AppRadius.circular8,
        border: Border.all(color: AppColors.actionBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.skyBlue),
          SizedBox(width: 1.w),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIconButton({
    required Widget icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 3.w),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circular12,
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular12,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: icon,
          ),
        ),
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
      children: [
        icon,
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 0.3.h),
        Text(
          title,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circular16,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.incorrectContainer : AppColors.card,
          borderRadius: AppRadius.circular16,
          border: Border.all(
            color: isDestructive ? AppColors.incorrectBorder : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.alertRed.withValues(alpha: 0.15)
                    : AppColors.actionBlue.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular10,
              ),
              child: icon,
            ),
            SizedBox(width: 3.5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isDestructive ? AppColors.errorText : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDestructive ? AppColors.alertRed.withValues(alpha: 0.8) : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AppIcons.arrowRight(
              color: isDestructive ? AppColors.errorText : AppColors.textMuted,
              size: AppSizes.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}
