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

class _AppShimmerState extends State<AppShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                AppColors.card,
                AppColors.borderSubtle.withValues(alpha: 0.5),
                AppColors.card,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + (_controller.value * 3.0), -0.3),
              end: Alignment(1.0 + (_controller.value * 3.0), 0.3),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class AppShimmerContainer extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const AppShimmerContainer({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: borderRadius ?? AppRadius.circular10,
      ),
    );
  }
}

class AppCardShimmer extends StatelessWidget {
  const AppCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.6),
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppShimmerContainer(width: 25.w, height: 2.5.h, borderRadius: AppRadius.circular8),
              AppShimmerContainer(width: 15.w, height: 2.h, borderRadius: AppRadius.circular6),
            ],
          ),
          SizedBox(height: 2.h),
          AppShimmerContainer(width: 60.w, height: 2.8.h, borderRadius: AppRadius.circular8),
          SizedBox(height: 1.h),
          AppShimmerContainer(width: double.infinity, height: 1.8.h, borderRadius: AppRadius.circular6),
          SizedBox(height: 0.8.h),
          AppShimmerContainer(width: 80.w, height: 1.8.h, borderRadius: AppRadius.circular6),
          SizedBox(height: 2.h),
          Row(
            children: [
              AppShimmerContainer(width: 20.w, height: 1.5.h, borderRadius: AppRadius.circular6),
              SizedBox(width: 3.w),
              AppShimmerContainer(width: 25.w, height: 1.5.h, borderRadius: AppRadius.circular6),
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
