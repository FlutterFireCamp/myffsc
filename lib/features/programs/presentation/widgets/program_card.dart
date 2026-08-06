import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/program_item.dart';

class ProgramCard extends StatelessWidget {
  final ProgramItem item;
  final ValueChanged<String?> onLaunchUrl;

  const ProgramCard({
    super.key,
    required this.item,
    required this.onLaunchUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasLive = item.sessionUrl != null && item.sessionUrl!.trim().isNotEmpty;
    final hasReplay = item.replayUrl != null && item.replayUrl!.trim().isNotEmpty;

    final badgeColor = item.type.badgeColor;
    final cardBgColor = item.type.cardBgColor;
    final borderColor = item.type.borderColor;

    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular8,
                  border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  item.type.label,
                  style: AppTextStyles.badge.copyWith(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (item.speaker != null && item.speaker!.isNotEmpty)
                Row(
                  children: [
                    AppIcons.user(size: 14, color: badgeColor),
                    SizedBox(width: 1.w),
                    Text(
                      item.speaker!,
                      style: AppTextStyles.caption.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text(
            item.title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            item.description,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 2.h),

          // Date & Horaire (Local Device Timezone + GMT Suffix) & Location
          Wrap(
            spacing: 3.w,
            runSpacing: 0.8.h,
            children: [
              if (item.date.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.calendar(size: 14, color: badgeColor),
                    SizedBox(width: 1.w),
                    Text(
                      item.date,
                      style: AppTextStyles.caption.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              if (item.time.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.timer(size: 14, color: badgeColor),
                    SizedBox(width: 1.w),
                    Text(
                      item.formattedLocalTime,
                      style: AppTextStyles.caption.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              if (item.location != null && item.location!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.video(size: 14, color: AppColors.textMuted),
                    SizedBox(width: 1.w),
                    Text(
                      item.location!,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
            ],
          ),

          if (hasLive || hasReplay) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                if (hasLive)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => onLaunchUrl(item.sessionUrl),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: badgeColor),
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular10,
                        ),
                      ),
                      icon: AppIcons.video(size: AppSizes.iconSm, color: badgeColor),
                      label: Text(
                        "Rejoindre Live",
                        style: AppTextStyles.buttonSmall.copyWith(color: badgeColor),
                      ),
                    ),
                  ),
                if (hasLive && hasReplay) SizedBox(width: 2.w),
                if (hasReplay)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onLaunchUrl(item.replayUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ultraDark,
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular10,
                        ),
                      ),
                      icon: AppIcons.video(size: AppSizes.iconSm, color: AppColors.textPrimary),
                      label: Text(
                        "Replay",
                        style: AppTextStyles.buttonSmall.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
