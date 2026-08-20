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
      duration: const Duration(milliseconds: 1400),
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
                Color(0xFF1E293B), // Fond sombre bleuté bien contrasté
                Color(0xFF3B4F6E), // Lueur claire bien visible
                Color(0xFF1E293B), // Retour fond sombre
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

/// Un élément rectangulaire skeleton avec des bords arrondis configurables
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
        color: color ?? const Color(0xFF1E293B),
        borderRadius: borderRadius ?? AppRadius.circular8,
      ),
    );
  }
}

/// Un élément circulaire skeleton (avatar, icône ronde, badge rond)
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
        color: color ?? const Color(0xFF1E293B),
        shape: .circle,
      ),
    );
  }
}

/// Carte squelette générique pour listes
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
                color: const Color(0xFF26354D),
              ),
              AppShimmerBox(
                width: 16.w,
                height: 1.8.h,
                borderRadius: AppRadius.circular6,
                color: const Color(0xFF1E293B),
              ),
            ],
          ),
          SizedBox(height: 1.8.h),
          AppShimmerBox(
            width: 70.w,
            height: 2.4.h,
            borderRadius: AppRadius.circular8,
            color: const Color(0xFF2E3E59),
          ),
          SizedBox(height: 1.h),
          AppShimmerBox(
            width: double.infinity,
            height: 1.5.h,
            borderRadius: AppRadius.circular6,
            color: const Color(0xFF1E293B),
          ),
          SizedBox(height: 0.8.h),
          AppShimmerBox(
            width: 80.w,
            height: 1.5.h,
            borderRadius: AppRadius.circular6,
            color: const Color(0xFF1E293B),
          ),
          SizedBox(height: 2.h),
          Row(
            spacing: 3.w,
            children: [
              AppShimmerBox(
                width: 22.w,
                height: 1.6.h,
                borderRadius: AppRadius.circular6,
                color: const Color(0xFF24344C),
              ),
              AppShimmerBox(
                width: 28.w,
                height: 1.6.h,
                borderRadius: AppRadius.circular6,
                color: const Color(0xFF24344C),
              ),
            ],
          ),
        ],
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
    return AppShimmer(
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        itemCount: itemCount,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) => const AppCardShimmer(),
      ),
    );
  }
}
