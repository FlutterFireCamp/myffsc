import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ProfileSocialLinksBar extends StatelessWidget {
  final UserEntity user;

  const ProfileSocialLinksBar({super.key, required this.user});

  bool get hasSocialLinks =>
      (user.discordUsername != null && user.discordUsername!.trim().isNotEmpty) ||
      (user.github != null && user.github!.trim().isNotEmpty) ||
      (user.linkedin != null && user.linkedin!.trim().isNotEmpty) ||
      (user.x != null && user.x!.trim().isNotEmpty) ||
      (user.portfolio != null && user.portfolio!.trim().isNotEmpty);

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

  Future<void> _handleDiscordTap(BuildContext context, String? discord) async {
    if (discord == null || discord.trim().isEmpty) return;
    final val = discord.trim();
    if (val.startsWith('http://') || val.startsWith('https://')) {
      _launchExternalUrl(context, val);
    } else {
      await Clipboard.setData(ClipboardData(text: val));
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          "Pseudo Discord copié : $val",
        );
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
        // 1. Discord (Au premier rang)
        if (user.discordUsername != null && user.discordUsername!.trim().isNotEmpty)
          _buildSocialIconButton(
            icon: AppIcons.discord(size: 16),
            tooltip: "Discord : ${user.discordUsername}",
            onTap: () => _handleDiscordTap(context, user.discordUsername),
          ),
        // 2. GitHub
        if (user.github != null && user.github!.trim().isNotEmpty)
          _buildSocialIconButton(
            icon: AppIcons.github(size: 16),
            tooltip: "GitHub",
            onTap: () => _launchExternalUrl(context, user.github),
          ),
        // 3. LinkedIn
        if (user.linkedin != null && user.linkedin!.trim().isNotEmpty)
          _buildSocialIconButton(
            icon: AppIcons.linkedin(size: 16),
            tooltip: "LinkedIn",
            onTap: () => _launchExternalUrl(context, user.linkedin),
          ),
        // 4. X / Twitter
        if (user.x != null && user.x!.trim().isNotEmpty)
          _buildSocialIconButton(
            icon: AppIcons.twitter(size: 16),
            tooltip: "X / Twitter",
            onTap: () => _launchExternalUrl(context, user.x),
          ),
        // 5. Portfolio
        if (user.portfolio != null && user.portfolio!.trim().isNotEmpty)
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
