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
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Left
              AppCachedAvatar(
                imageUrl: user.photoUrl,
                radius: 36,
                fallbackInitial: user.firstName,
                fallbackTextStyle: AppTextStyles.h2.copyWith(color: Colors.white),
              ),
              SizedBox(width: 4.w),

              // Info Column Right
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

                    // Location & Hub/Community Badges
                    if (locationText.isNotEmpty || (hubText != null && hubText.isNotEmpty)) ...[
                      SizedBox(height: 1.2.h),
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

                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ],
          ),

          // Pencil Edit Icon Button
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(user: user),
                  ),
                );
              },
              borderRadius: AppRadius.circular12,
              child: Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  color: AppColors.actionBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular12,
                  border: Border.all(color: AppColors.actionBlue.withValues(alpha: 0.3)),
                ),
                child: AppIcons.edit(color: AppColors.skyBlue, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeChip({required IconData icon, required String text}) {
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
          Icon(icon, size: 18, color: AppColors.skyBlue),
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
