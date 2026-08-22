import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String fallbackInitial;
  final TextStyle? fallbackTextStyle;
  final Color backgroundColor;

  const AppAvatar({
    super.key,
    required this.imageUrl,
    required this.radius,
    required this.fallbackInitial,
    this.fallbackTextStyle,
    this.backgroundColor = AppColors.navyCard,
  });

  /// Détecte si l'URL correspond à une image générique/initiale par défaut générée par Google
  static bool isDefaultGoogleAvatar(String? url) {
    if (url == null || url.trim().isEmpty) return true;
    final trimmed = url.trim();

    if (trimmed.contains('googleusercontent.com')) {
      // Anciennes URLs de silhouette par défaut
      if (trimmed.contains('/AAAAAAAAAAI/AAAAAAAAAAA/') ||
          trimmed.contains('default-user') ||
          trimmed.contains('default_avatar')) {
        return true;
      }

      // Google Identity : '/a/' (sans tiret) = initiale générée par Google
      // '/a-/' (avec tiret) ou '/ogw/' = vraie photo de profil personnalisée
      final uri = Uri.tryParse(trimmed);
      if (uri != null) {
        final path = uri.path;
        if (path.startsWith('/a/') && !path.startsWith('/a-/')) {
          return true;
        }
      }
    }

    return false;
  }

  Widget _buildFallback(TextStyle resolvedStyle) {
    final letter = fallbackInitial.trim().isNotEmpty
        ? fallbackInitial.trim()[0].toUpperCase()
        : 'A';

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: .circle,
        border: .all(color: AppColors.navyBorder, width: 1.0),
      ),
      alignment: Alignment.center,
      child: Text(letter, style: resolvedStyle, textAlign: TextAlign.center),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle resolvedStyle = fallbackTextStyle != null
        ? fallbackTextStyle!.copyWith(fontFamily: AppTextStyles.fontFamily)
        : AppTextStyles.avatarInitial(radius * 1.05);

    // Si aucune image ou si c'est l'avatar par défaut de Google, appliquer notre design FFSC
    if (imageUrl == null ||
        imageUrl!.trim().isEmpty ||
        isDefaultGoogleAvatar(imageUrl)) {
      return _buildFallback(resolvedStyle);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) => Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: .circle,
          image: DecorationImage(image: imageProvider, fit: .cover),
        ),
      ),
      placeholder: (context, url) => Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          color: AppColors.card,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: AppIcons.user(color: AppColors.skyBlue, size: radius * 1.1),
      ),
      errorWidget: (context, url, error) => _buildFallback(resolvedStyle),
    );
  }
}
