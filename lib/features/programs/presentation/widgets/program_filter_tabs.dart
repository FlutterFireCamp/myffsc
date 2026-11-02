import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/program_item.dart';

class ProgramFilterTabs extends StatelessWidget {
  final ProgramType? selectedTypeFilter;
  final ValueChanged<ProgramType?> onSelectFilter;

  const ProgramFilterTabs({
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
        spacing: 2.w,
        children: [
          _buildFilterTab(
            label: "Tous",
            isSelected: selectedTypeFilter == null,
            badgeColor: AppColors.skyBlue,
            onTap: () => onSelectFilter(null),
          ),
          _buildFilterTab(
            label: "Sessions",
            isSelected: selectedTypeFilter == ProgramType.session,
            badgeColor: ProgramType.session.badgeColor,
            iconBuilder: (color) => AppIcons.video(color: color, size: 16),
            onTap: () => onSelectFilter(ProgramType.session),
          ),
          _buildFilterTab(
            label: "Workshops",
            isSelected: selectedTypeFilter == ProgramType.workshop,
            badgeColor: ProgramType.workshop.badgeColor,
            iconBuilder: (color) => AppIcons.star(color: color, size: 16),
            onTap: () => onSelectFilter(ProgramType.workshop),
          ),
          _buildFilterTab(
            label: "Conférences",
            isSelected: selectedTypeFilter == ProgramType.conference,
            badgeColor: ProgramType.conference.badgeColor,
            iconBuilder: (color) => AppIcons.userGroup(color: color, size: 16),
            onTap: () => onSelectFilter(ProgramType.conference),
          ),
          _buildFilterTab(
            label: "Groupes d'étude",
            isSelected: selectedTypeFilter == ProgramType.studyGroup,
            badgeColor: ProgramType.studyGroup.badgeColor,
            iconBuilder: (color) => AppIcons.userGroup(color: color, size: 16),
            onTap: () => onSelectFilter(ProgramType.studyGroup),
          ),
          _buildFilterTab(
            label: "Évaluation",
            isSelected: selectedTypeFilter == ProgramType.test,
            badgeColor: ProgramType.test.badgeColor,
            iconBuilder: (color) => AppIcons.tests(color: color, size: 16),
            onTap: () => onSelectFilter(ProgramType.test),
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
    final textColor =
        isSelected ? AppColors.activeTabText : AppColors.textSecondary;

    final iconColor =
        isSelected ? AppColors.activeTabText : AppColors.textSecondary;

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
          mainAxisSize: MainAxisSize.min,
          spacing: 1.5.w,
          children: [
            if (iconBuilder != null) iconBuilder(iconColor),
            Text(
              label,
              style: AppTextStyles.tabLabel.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
