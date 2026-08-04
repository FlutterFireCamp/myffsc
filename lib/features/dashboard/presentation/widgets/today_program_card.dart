import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../programs/domain/entities/program_item.dart';

class TodayProgramCard extends StatelessWidget {
  final ProgramItem program;
  final ValueChanged<String?> onLaunchUrl;

  const TodayProgramCard({
    super.key,
    required this.program,
    required this.onLaunchUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasLive = program.sessionUrl != null && program.sessionUrl!.trim().isNotEmpty;
    final hasReplay = program.replayUrl != null && program.replayUrl!.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppColors.actionBlue.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: AppIcons.video(color: AppColors.actionBlue, size: 24),
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                      decoration: BoxDecoration(
                        color: AppColors.actionBlue.withValues(alpha: 0.12),
                        borderRadius: AppRadius.circular6,
                      ),
                      child: Text(
                        program.type.label,
                        style: AppTextStyles.badge.copyWith(
                          color: AppColors.actionBlue,
                          fontSize: 8.5.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      program.title,
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 0.3.h),
                    Row(
                      children: [
                        AppIcons.calendar(size: 13, color: AppColors.textMuted),
                        SizedBox(width: 1.w),
                        Text(
                          "${program.date} ${program.time.isNotEmpty ? '• ${program.time}' : ''}",
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
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
                      onPressed: () => onLaunchUrl(program.sessionUrl),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.skyBlue),
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular10,
                        ),
                      ),
                      icon: AppIcons.video(size: AppSizes.iconSm, color: AppColors.skyBlue),
                      label: Text(
                        "Rejoindre Live",
                        style: AppTextStyles.buttonSmall.copyWith(color: AppColors.skyBlue),
                      ),
                    ),
                  ),
                if (hasLive && hasReplay) SizedBox(width: 2.w),
                if (hasReplay)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onLaunchUrl(program.replayUrl),
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
