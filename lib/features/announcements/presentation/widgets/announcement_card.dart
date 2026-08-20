import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/announcement_item.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementItem item;

  const AnnouncementCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: item.type.cardBgColor,
        borderRadius: AppRadius.circular16,
        border: Border.all(
          color: item.type.borderColor,
          width: item.type == AnnouncementType.urgent ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: item.type.badgeBgColor,
                  borderRadius: AppRadius.circular8,
                  border: Border.all(color: item.type.borderColor),
                ),
                child: Row(
                  mainAxisSize: .min,
                  spacing: 1.5.w,
                  children: [
                    item.type.icon,
                    Text(
                      item.type.label,
                      style: AppTextStyles.badge.copyWith(
                        color: item.type.color,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.8.h),
          Text(
            item.title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: .bold,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            item.description,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Row(
                spacing: 1.w,
                children: [
                  AppIcons.calendar(size: 14, color: AppColors.textMuted),
                  Text(
                    item.formattedFrenchDate,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
