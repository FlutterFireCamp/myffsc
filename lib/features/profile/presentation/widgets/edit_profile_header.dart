import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';

class EditProfileHeader extends StatelessWidget {
  final UserEntity user;

  const EditProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final countryWithFlag =
        AppDataConstants.formatWithFlag(user.country, flagAtEnd: true);
    final locationText = [
      if (user.town != null && user.town!.isNotEmpty) user.town,
      if (countryWithFlag.isNotEmpty) countryWithFlag,
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
        crossAxisAlignment: .center,
        spacing: 4.w,
        children: [
          AppCachedAvatar(
            imageUrl: user.photoUrl,
            radius: 32,
            fallbackInitial: user.firstName,
            fallbackTextStyle: AppTextStyles.h2.copyWith(color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: .bold,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: .ellipsis,
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
                    alignment: .start,
                    runAlignment: .start,
                    crossAxisAlignment: .start,
                    children: [
                      if (locationText.isNotEmpty)
                        _buildBadgeChip(
                          icon: AppIcons.location04(
                            color: AppColors.actionBlue,
                            size: 18,
                          ),
                          text: locationText,
                        ),
                      if (hubText != null && hubText.isNotEmpty)
                        _buildBadgeChip(
                          icon: AppIcons.userGroup(
                            color: AppColors.actionBlue,
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
        mainAxisSize: .min,
        spacing: 2.w,
        children: [
          icon,
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: .ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: .w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
