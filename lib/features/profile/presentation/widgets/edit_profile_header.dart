import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';

class EditProfileHeader extends StatelessWidget {
  final UserEntity user;

  const EditProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final locationText = [
      if (user.town != null && user.town!.isNotEmpty) user.town,
      if (user.country != null && user.country!.isNotEmpty) user.country,
    ].join(', ');

    final hubText = user.hub ?? user.community;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCachedAvatar(
            imageUrl: user.photoUrl,
            radius: 32,
            fallbackInitial: user.firstName,
            fallbackTextStyle: AppTextStyles.h2.copyWith(color: Colors.white),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  user.email,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                if (locationText.isNotEmpty || (hubText != null && hubText.isNotEmpty)) ...[
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 0.8.h,
                    children: [
                      if (locationText.isNotEmpty)
                        _buildBadgeChip(
                          icon: Icons.location_on_outlined,
                          text: locationText,
                        ),
                      if (hubText != null && hubText.isNotEmpty)
                        _buildBadgeChip(
                          icon: Icons.groups_outlined,
                          text: hubText,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeChip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: AppColors.actionBlue.withValues(alpha: 0.12),
        borderRadius: AppRadius.circular8,
        border: Border.all(color: AppColors.actionBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.skyBlue),
          SizedBox(width: 1.w),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
