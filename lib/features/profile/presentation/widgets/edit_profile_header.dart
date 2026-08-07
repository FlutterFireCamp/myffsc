import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';

class EditProfileHeader extends StatelessWidget {
  final UserEntity user;

  const EditProfileHeader({super.key, required this.user});

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
        crossAxisAlignment: CrossAxisAlignment.center,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (locationText.isNotEmpty ||
                    (hubText != null && hubText.isNotEmpty)) ...[
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 0.8.h,
                    alignment: .center,
                    runAlignment: .center,
                    crossAxisAlignment: .center,
                    children: [
                      if (locationText.isNotEmpty)
                        _buildBadgeChip(
                          icon: AppIcons.location04(
                            color: AppColors.skyBlue,
                            size: 18,
                          ),
                          text: locationText,
                        ),
                      if (hubText != null && hubText.isNotEmpty)
                        _buildBadgeChip(
                          icon: AppIcons.userGroup(
                            color: AppColors.skyBlue,
                            size: 18,
                          ),
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

  Widget _buildBadgeChip({required Widget icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: AppColors.actionBlue.withValues(alpha: 0.12),
        borderRadius: AppRadius.circular8,
        border: Border.all(color: AppColors.actionBlue.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12.5.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
