import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    final isTest = program.type == ProgramType.test;
    final hasLive =
        (program.sessionUrl != null && program.sessionUrl!.trim().isNotEmpty) ||
        isTest;
    final hasReplay =
        program.replayUrl != null && program.replayUrl!.trim().isNotEmpty;

    final badgeColor = program.type.badgeColor;
    final cardBgColor = program.type.cardBgColor;
    final borderColor = program.type.borderColor;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 3.5.w,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  shape: .circle,
                ),
                child: isTest
                    ? AppIcons.tests(color: badgeColor, size: 24)
                    : AppIcons.video(color: badgeColor, size: 24),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 0.4.h,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.15),
                        borderRadius: AppRadius.circular6,
                        border: Border.all(
                          color: badgeColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        program.type.label,
                        style: AppTextStyles.badge.copyWith(
                          color: badgeColor,
                        ),
                      ),
                    ),
                    Text(
                      program.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: .bold,
                      ),
                    ),
                    Row(
                      spacing: 1.w,
                      children: [
                        AppIcons.calendar(size: 13, color: badgeColor),
                        Expanded(
                          child: Text(
                            "${program.formattedFrenchDate} ${program.time.isNotEmpty ? '• ${program.formattedLocalTime}' : ''}",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: badgeColor,
                              fontWeight: .w600,
                            ),
                            maxLines: 1,
                            overflow: .ellipsis,
                          ),
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
              spacing: 2.w,
              children: [
                if (hasLive)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (isTest) {
                          context.go('/tests');
                        } else {
                          onLaunchUrl(program.sessionUrl);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: badgeColor),
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular10,
                        ),
                      ),
                      icon: isTest
                          ? AppIcons.tests(
                              size: AppSizes.iconSm,
                              color: badgeColor,
                            )
                          : AppIcons.video(
                              size: AppSizes.iconSm,
                              color: badgeColor,
                            ),
                      label: Text(
                        isTest ? "Rejoindre le Test" : "Rejoindre Live",
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ),
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
                      icon: AppIcons.video(
                        size: AppSizes.iconSm,
                        color: AppColors.textPrimary,
                      ),
                      label: Text(
                        "Replay",
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
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
