import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ProfileMetricsCard extends StatelessWidget {
  final UserEntity user;

  const ProfileMetricsCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MetricItem(
            title: "Niveau",
            value: "Niveau ${user.level}",
            icon: AppIcons.badge(color: AppColors.skyBlue, size: AppSizes.iconLg),
          ),
          Container(width: 1, height: 40, color: AppColors.borderSubtle),
          _MetricItem(
            title: "Points FFSC",
            value: "${user.totalPoints} pts",
            icon: AppIcons.star(color: AppColors.firebaseYellow, size: AppSizes.iconLg),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 0.3.h),
        Text(
          title,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
