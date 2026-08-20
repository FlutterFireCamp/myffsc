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
      scrollDirection: .horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        spacing: 2.w,
        children: [
          _buildFilterTab(
            label: "Toutes",
            isSelected: selectedTypeFilter == null,
            badgeColor: AppColors.skyBlue,
            onTap: () => onSelectFilter(null),
          ),
          _buildFilterTab(
            label: "Informations",
            isSelected: selectedTypeFilter == AnnouncementType.info,
            badgeColor: AppColors.skyBlue,
            iconBuilder: (color) => AppIcons.infoCircle(color: color, size: 16),
            onTap: () => onSelectFilter(AnnouncementType.info),
          ),
          _buildFilterTab(
            label: "Flash Info",
            isSelected: selectedTypeFilter == AnnouncementType.important,
            badgeColor: AnnouncementType.important.color,
            iconBuilder: (color) => AppIcons.flashInfo(color: color, size: 16),
            onTap: () => onSelectFilter(AnnouncementType.important),
          ),
          _buildFilterTab(
            label: "Urgences",
            isSelected: selectedTypeFilter == AnnouncementType.urgent,
            badgeColor: AnnouncementType.urgent.color,
            iconBuilder: (color) => AppIcons.warning(color: color, size: 16),
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
    Widget Function(Color color)? iconBuilder,
    required VoidCallback onTap,
  }) {
    final isAllTab =
        label.toLowerCase() == "toutes" || label.toLowerCase() == "tous";
    final textColor = isSelected
        ? (isAllTab ? Colors.white : const Color(0xFF111827))
        : AppColors.textSecondary;

    final iconColor = isSelected
        ? (isAllTab ? Colors.white : const Color(0xFF111827))
        : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circular12,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? badgeColor
              : AppColors.cardHover.withValues(alpha: 0.5),
          borderRadius: AppRadius.circular12,
          border: Border.all(
            color: isSelected ? badgeColor : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: .min,
          spacing: 1.5.w,
          children: [
            if (iconBuilder != null) iconBuilder(iconColor),
            Text(
              label,
              style: AppTextStyles.tabLabel.copyWith(
                color: textColor,
                fontWeight: isSelected ? .bold : .w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
