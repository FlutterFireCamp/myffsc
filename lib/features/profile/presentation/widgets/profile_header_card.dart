import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../pages/edit_profile_page.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserEntity user;

  const ProfileHeaderCard({
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
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular20,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar Left
              AppCachedAvatar(
                imageUrl: user.photoUrl,
                radius: 34,
                fallbackInitial: user.firstName,
                fallbackTextStyle: AppTextStyles.h2.copyWith(color: Colors.white),
              ),
              SizedBox(width: 4.w),

              // Name & Email Column
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
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Location & Hub/Community Badges
          if (locationText.isNotEmpty || (hubText != null && hubText.isNotEmpty)) ...[
            Wrap(
              spacing: 2.w,
              runSpacing: 0.8.h,
              children: [
                if (locationText.isNotEmpty)
                  _buildBadgeChip(
                    icon: AppIcons.location04(color: AppColors.skyBlue, size: 18),
                    text: locationText,
                  ),
                if (hubText != null && hubText.isNotEmpty)
                  _buildBadgeChip(
                    icon: AppIcons.userGroup(color: AppColors.skyBlue, size: 18),
                    text: hubText,
                  ),
              ],
            ),
            SizedBox(height: 2.h),
          ],

          // Edit Profile Button placed cleanly inside the Column
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(user: user),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.skyBlue,
                side: BorderSide(color: AppColors.skyBlue.withValues(alpha: 0.5), width: 1.2),
                padding: EdgeInsets.symmetric(vertical: 1.2.h),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.circular12,
                ),
              ),
              icon: AppIcons.edit(color: AppColors.skyBlue, size: 18),
              label: Text(
                "Éditer mon profil",
                style: AppTextStyles.buttonSmall.copyWith(
                  color: AppColors.skyBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeChip({required Widget icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.9.h),
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
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12.5.sp,
            ),
          ),
        ],
      ),
    );
  }
}
