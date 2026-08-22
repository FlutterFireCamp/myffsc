import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';

typedef AppCachedAvatar = AppAvatar;

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

  Widget _buildFallback(TextStyle resolvedStyle) {
    final letter = fallbackInitial.trim().isNotEmpty
        ? fallbackInitial.trim()[0].toUpperCase()
        : 'A';

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.navyBorder, width: 1.0),
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

    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return _buildFallback(resolvedStyle);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) => Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
