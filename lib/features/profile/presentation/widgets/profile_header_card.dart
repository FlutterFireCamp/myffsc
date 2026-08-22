import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserEntity user;

  const ProfileHeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final countryWithFlag = AppDataConstants.formatWithFlag(
      user.country,
      flagAtEnd: true,
    );
    final locationText = [
      if (user.town != null && user.town!.isNotEmpty) user.town,
      if (countryWithFlag.isNotEmpty) countryWithFlag,
    ].join(', ');

    final hubText = user.hub ?? user.community;

    return Container(
      padding: .all(5.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular20,
        border: .all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 1.h,
        children: [
          // Row 1: Avatar (Left) + Details (Name, Email, Location & Hub Badges)
          Row(
            crossAxisAlignment: .start,
            spacing: 3.w,
            children: [
              // Avatar Left
              AppAvatar(
                imageUrl: user.photoUrl,
                radius: 26,
                fallbackInitial: user.firstName,
                fallbackTextStyle: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                ),
              ),

              // Name, Email & Badges Column (Align Start)
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  spacing: 0.4.h,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: .bold,
                      ),
                    ),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    // Location & Hub/Community Badges inside the same column starting at the left
                    if (locationText.isNotEmpty ||
                        (hubText != null && hubText.isNotEmpty)) ...[
                      SizedBox(height: 0.4.h),
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
                                color: AppColors.skyBlue,
                                size: 14,
                              ),
                              text: locationText,
                            ),
                          if (hubText != null && hubText.isNotEmpty)
                            _buildBadgeChip(
                              icon: AppIcons.userGroup(
                                color: AppColors.skyBlue,
                                size: 14,
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

          // Row 2: Edit Button aligned to the right (.end)
          Row(
            mainAxisAlignment: .end,
            children: [
              InkWell(
                onTap: () {
                  context.push(RoutePaths.editProfile, extra: user);
                },
                borderRadius: AppRadius.circular12,
                child: Container(
                  padding: .all(0.8.h),
                  decoration: BoxDecoration(
                    color: AppColors.skyBlue.withValues(alpha: 0.15),
                    borderRadius: AppRadius.circular12,
                    border: .all(
                      color: AppColors.skyBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: AppIcons.edit(color: AppColors.skyBlue, size: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeChip({required Widget icon, required String text}) {
    return Container(
      padding: .symmetric(horizontal: 2.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppColors.skyBlue.withValues(alpha: 0.12),
        borderRadius: AppRadius.circular8,
        border: .all(color: AppColors.skyBlue.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: 1.5.w,
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
