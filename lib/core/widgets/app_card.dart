import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardDecoration = BoxDecoration(
      color: backgroundColor ?? AppColors.card,
      borderRadius: AppRadius.circular20,
      border: border ?? Border.all(color: AppColors.borderSubtle),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circular20,
        child: Container(
          padding: padding ?? EdgeInsets.all(5.w),
          decoration: cardDecoration,
          child: child,
        ),
      );
    }

    return Container(
      padding: padding ?? EdgeInsets.all(5.w),
      decoration: cardDecoration,
      child: child,
    );
  }
}
