import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ProfileSocialLinksBar extends StatelessWidget {
  final UserEntity user;

  const ProfileSocialLinksBar({super.key, required this.user});

  bool get hasSocialLinks =>
      (user.github != null && user.github!.isNotEmpty) ||
      (user.linkedin != null && user.linkedin!.isNotEmpty) ||
      (user.x != null && user.x!.isNotEmpty) ||
      (user.portfolio != null && user.portfolio!.isNotEmpty);

  Future<void> _launchExternalUrl(
    BuildContext context,
    String? urlString,
  ) async {
    if (urlString == null || urlString.trim().isEmpty) return;
    final Uri url = Uri.parse(
      urlString.startsWith('http') ? urlString : 'https://$urlString',
    );
    try {
      if (!await launchUrl(url, mode: .externalApplication)) {
        if (context.mounted) {
          AppSnackBar.showError(
            context,
            "Impossible d'ouvrir le lien : $urlString",
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showError(context, "Erreur lors de l'ouverture : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!hasSocialLinks) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: .center,
      spacing: 2.5.w,
      children: [
        if (user.github != null && user.github!.isNotEmpty)
          _buildSocialIconButton(
            icon: AppIcons.github(size: 16),
            tooltip: "GitHub",
            onTap: () => _launchExternalUrl(context, user.github),
          ),
        if (user.linkedin != null && user.linkedin!.isNotEmpty)
          _buildSocialIconButton(
            icon: AppIcons.linkedin(size: 16),
            tooltip: "LinkedIn",
            onTap: () => _launchExternalUrl(context, user.linkedin),
          ),
        if (user.x != null && user.x!.isNotEmpty)
          _buildSocialIconButton(
            icon: AppIcons.twitter(size: 16),
            tooltip: "X / Twitter",
            onTap: () => _launchExternalUrl(context, user.x),
          ),
        if (user.portfolio != null && user.portfolio!.isNotEmpty)
          _buildSocialIconButton(
            icon: AppIcons.globe02(size: 16),
            tooltip: "Portfolio",
            onTap: () => _launchExternalUrl(context, user.portfolio),
          ),
      ],
    );
  }

  Widget _buildSocialIconButton({
    required Widget icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circular12,
        child: Container(
          padding: EdgeInsets.all(2.2.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: AppRadius.circular12,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: icon,
        ),
      ),
    );
  }
}
