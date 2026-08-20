import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class CompleteProfileHeader extends StatelessWidget {
  final String emailText;
  final String? photoUrl;

  const CompleteProfileHeader({
    super.key,
    required this.emailText,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        spacing: 3.5.w,
        children: [
          CircleAvatar(
            radius: 5.w,
            backgroundColor: AppColors.actionBlue.withValues(alpha: 0.2),
            backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                ? NetworkImage(photoUrl!)
                : null,
            child: (photoUrl == null || photoUrl!.isEmpty)
                ? AppIcons.user(size: 20, color: AppColors.actionBlue)
                : null,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 0.3.h,
              children: [
                Row(
                  spacing: 1.5.w,
                  children: [
                    Text(
                      "Compte Google",
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: .w600,
                      ),
                    ),
                    AppIcons.check(color: AppColors.correctText, size: 14),
                  ],
                ),
                Text(
                  emailText,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: .bold,
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
