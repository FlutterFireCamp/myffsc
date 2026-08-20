import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/theme.dart';

class AppShimmer extends StatefulWidget {
  final Widget child;

  const AppShimmer({
    super.key,
    required this.child,
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: .srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Color(0xFF222F44), // Base sombre bleutée
                Color(0xFF3E5478), // Lueur brillante bien visible
                Color(0xFF222F44), // Retour base
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.2 + (_controller.value * 3.4), -0.2),
              end: Alignment(1.2 + (_controller.value * 3.4), 0.2),
              tileMode: .clamp,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Bloc rectangulaire squelette représentant une ligne de texte, un bouton ou un badge
class AppShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? color;

  const AppShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF222F44),
        borderRadius: borderRadius ?? AppRadius.circular6,
      ),
    );
  }
}

/// Élément circulaire squelette pour avatars et icônes rondes
class AppShimmerCircle extends StatelessWidget {
  final double radius;
  final Color? color;

  const AppShimmerCircle({
    super.key,
    required this.radius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF222F44),
        shape: .circle,
      ),
    );
  }
}

/// Carte squelette générique avec fond et bordures réelles non masquées
class AppCardShimmer extends StatelessWidget {
  const AppCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                AppShimmerBox(
                  width: 25.w,
                  height: 2.2.h,
                  borderRadius: AppRadius.circular8,
                ),
                AppShimmerBox(
                  width: 16.w,
                  height: 1.8.h,
                  borderRadius: AppRadius.circular6,
                ),
              ],
            ),
            SizedBox(height: 1.8.h),
            AppShimmerBox(
              width: 70.w,
              height: 2.2.h,
              borderRadius: AppRadius.circular8,
            ),
            SizedBox(height: 1.h),
            AppShimmerBox(
              width: double.infinity,
              height: 1.4.h,
              borderRadius: AppRadius.circular4,
            ),
            SizedBox(height: 0.6.h),
            AppShimmerBox(
              width: 75.w,
              height: 1.4.h,
              borderRadius: AppRadius.circular4,
            ),
            SizedBox(height: 2.h),
            Row(
              spacing: 3.w,
              children: [
                AppShimmerBox(
                  width: 22.w,
                  height: 1.6.h,
                  borderRadius: AppRadius.circular6,
                ),
                AppShimmerBox(
                  width: 28.w,
                  height: 1.6.h,
                  borderRadius: AppRadius.circular6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppListShimmer extends StatelessWidget {
  final int itemCount;

  const AppListShimmer({
    super.key,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) => const AppCardShimmer(),
    );
  }
}
