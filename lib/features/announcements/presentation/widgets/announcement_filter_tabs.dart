import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/announcement_item.dart';

class AnnouncementFilterTabs extends StatelessWidget {
  final AnnouncementType? selectedTypeFilter;
  final ValueChanged<AnnouncementType?> onSelectFilter;

  const AnnouncementFilterTabs({
    super.key,
    required this.selectedTypeFilter,
    required this.onSelectFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        children: [
          _buildFilterTab(
            label: "Toutes",
            isSelected: selectedTypeFilter == null,
            badgeColor: AppColors.skyBlue,
            onTap: () => onSelectFilter(null),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Informations",
            isSelected: selectedTypeFilter == AnnouncementType.info,
            badgeColor: AppColors.skyBlue,
            icon: AppIcons.infoCircle(
              color: AppColors.skyBlue,
              size: 16,
            ),
            onTap: () => onSelectFilter(AnnouncementType.info),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Flash Info",
            isSelected: selectedTypeFilter == AnnouncementType.important,
            badgeColor: AppColors.firebaseYellow,
            icon: AppIcons.flashInfo(
              color: AppColors.firebaseYellow,
              size: 16,
            ),
            onTap: () => onSelectFilter(AnnouncementType.important),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Urgences",
            isSelected: selectedTypeFilter == AnnouncementType.urgent,
            badgeColor: AppColors.errorText,
            icon: AppIcons.alert02(
              color: AppColors.errorText,
              size: 16,
            ),
            onTap: () => onSelectFilter(AnnouncementType.urgent),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required bool isSelected,
    required Color badgeColor,
    Widget? icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circular12,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? badgeColor.withValues(alpha: 0.2) : AppColors.card,
          borderRadius: AppRadius.circular12,
          border: Border.all(
            color: isSelected ? badgeColor : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              SizedBox(width: 1.5.w),
            ],
            Text(
              label,
              style: AppTextStyles.buttonSmall.copyWith(
                color: isSelected ? badgeColor : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
