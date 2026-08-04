import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ProfileSocialLinksBar extends StatelessWidget {
  final UserEntity user;

  const ProfileSocialLinksBar({
    super.key,
    required this.user,
  });

  bool get hasSocialLinks =>
      (user.github != null && user.github!.isNotEmpty) ||
      (user.linkedin != null && user.linkedin!.isNotEmpty) ||
      (user.x != null && user.x!.isNotEmpty) ||
      (user.portfolio != null && user.portfolio!.isNotEmpty);

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
    if (!hasSocialLinks) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Réseaux & Liens",
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (user.github != null && user.github!.isNotEmpty)
              _buildSocialIconButton(
                icon: AppIcons.github(color: Colors.white, size: 20),
                tooltip: "GitHub",
                onTap: () => _launchExternalUrl(context, user.github),
              ),
            if (user.linkedin != null && user.linkedin!.isNotEmpty)
              _buildSocialIconButton(
                icon: AppIcons.linkedin(color: const Color(0xFF0A66C2), size: 20),
                tooltip: "LinkedIn",
                onTap: () => _launchExternalUrl(context, user.linkedin),
              ),
            if (user.x != null && user.x!.isNotEmpty)
              _buildSocialIconButton(
                icon: AppIcons.twitter(color: Colors.white, size: 20),
                tooltip: "X / Twitter",
                onTap: () => _launchExternalUrl(context, user.x),
              ),
            if (user.portfolio != null && user.portfolio!.isNotEmpty)
              _buildSocialIconButton(
                icon: AppIcons.link(color: AppColors.skyBlue, size: 20),
                tooltip: "Portfolio",
                onTap: () => _launchExternalUrl(context, user.portfolio),
              ),
          ],
        ),
        SizedBox(height: 3.h),
      ],
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
