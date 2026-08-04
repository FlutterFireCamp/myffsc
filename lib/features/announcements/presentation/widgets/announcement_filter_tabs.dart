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
            onTap: () => onSelectFilter(null),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Informations",
            isSelected: selectedTypeFilter == AnnouncementType.info,
            icon: AppIcons.info(
              color: selectedTypeFilter == AnnouncementType.info ? AppColors.ultraDark : AppColors.skyBlue,
              size: 16,
            ),
            onTap: () => onSelectFilter(AnnouncementType.info),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Flash Info",
            isSelected: selectedTypeFilter == AnnouncementType.important,
            icon: AppIcons.star(
              color: selectedTypeFilter == AnnouncementType.important ? AppColors.ultraDark : AppColors.firebaseYellow,
              size: 16,
            ),
            onTap: () => onSelectFilter(AnnouncementType.important),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Urgences",
            isSelected: selectedTypeFilter == AnnouncementType.urgent,
            icon: AppIcons.alert02(
              color: selectedTypeFilter == AnnouncementType.urgent ? AppColors.ultraDark : AppColors.errorText,
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
    Widget? icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circular12,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.skyBlue : AppColors.card,
          borderRadius: AppRadius.circular12,
          border: Border.all(
            color: isSelected ? AppColors.skyBlue : AppColors.borderSubtle,
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
                color: isSelected ? AppColors.ultraDark : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
