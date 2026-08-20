import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';

class AppCachedAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String fallbackInitial;
  final TextStyle? fallbackTextStyle;

  const AppCachedAvatar({
    super.key,
    required this.imageUrl,
    required this.radius,
    required this.fallbackInitial,
    this.fallbackTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultStyle = TextStyle(
      fontSize: radius * 0.8,
      color: Colors.white,
      fontWeight: .bold,
    );

    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.actionBlue,
        child: Text(
          fallbackInitial.isNotEmpty ? fallbackInitial[0].toUpperCase() : 'A',
          style: fallbackTextStyle ?? defaultStyle,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.card,
        child: AppIcons.user(
          color: AppColors.skyBlue,
          size: radius * 1.1,
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.actionBlue,
        child: Text(
          fallbackInitial.isNotEmpty ? fallbackInitial[0].toUpperCase() : 'A',
          style: fallbackTextStyle ?? defaultStyle,
        ),
      ),
    );
  }
}

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = .cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: AppColors.card,
        child: Center(
          child: AppIcons.user(
            color: AppColors.skyBlue,
            size: (width != null && height != null) ? (width! < height! ? width! * 0.5 : height! * 0.5) : 24,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: AppColors.card,
        child: const Center(
          child: Icon(
            Icons.broken_image_rounded,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
