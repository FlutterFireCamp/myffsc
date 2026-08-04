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
        children: [
          _buildFilterTab(
            label: "Tous",
            isSelected: selectedTypeFilter == null,
            onTap: () => onSelectFilter(null),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Sessions",
            isSelected: selectedTypeFilter == ProgramType.session,
            onTap: () => onSelectFilter(ProgramType.session),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Workshops",
            isSelected: selectedTypeFilter == ProgramType.workshop,
            onTap: () => onSelectFilter(ProgramType.workshop),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Conférences",
            isSelected: selectedTypeFilter == ProgramType.conference,
            onTap: () => onSelectFilter(ProgramType.conference),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Groupes d'étude",
            isSelected: selectedTypeFilter == ProgramType.studyGroup,
            onTap: () => onSelectFilter(ProgramType.studyGroup),
          ),
          SizedBox(width: 2.w),
          _buildFilterTab(
            label: "Tests",
            isSelected: selectedTypeFilter == ProgramType.test,
            onTap: () => onSelectFilter(ProgramType.test),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required bool isSelected,
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
        child: Text(
          label,
          style: AppTextStyles.buttonSmall.copyWith(
            color: isSelected ? AppColors.ultraDark : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
