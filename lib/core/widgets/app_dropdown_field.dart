import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/theme.dart';

class AppDropdownField extends StatelessWidget {
  final String? label;
  final String? value;
  final String hint;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final bool enableSearch;
  final String? Function(String?)? validator;

  const AppDropdownField({
    super.key,
    this.label,
    required this.value,
    required this.hint,
    required this.options,
    required this.onSelected,
    this.enableSearch = false,
    this.validator,
  });

  void _showModalPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AppDropdownModalSheet(
          title: label?.replaceAll(' *', '') ?? hint,
          selectedValue: value,
          options: options,
          enableSearch: enableSearch || options.length > 5,
          onSelected: onSelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: value,
      validator: validator,
      builder: (formFieldState) {
        final hasError = formFieldState.hasError;
        return Column(
          crossAxisAlignment: .start,
          children: [
            InkWell(
              onTap: () => _showModalPicker(context),
              borderRadius: AppRadius.circular12,
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.circular12,
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.circular12,
                    borderSide: BorderSide(
                      color: hasError
                          ? AppColors.errorText
                          : AppColors.borderSubtle,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.circular12,
                    borderSide: const BorderSide(
                      color: AppColors.skyBlue,
                      width: 1.5,
                    ),
                  ),
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 8.w,
                    minHeight: 0,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 3.5.w),
                    child: AppIcons.arrowDown(
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                child: Text(
                  value != null && value!.isNotEmpty ? value! : hint,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: value != null && value!.isNotEmpty
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                  overflow: .ellipsis,
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: EdgeInsets.only(top: 0.6.h, left: 3.w),
                child: Text(
                  formFieldState.errorText ?? '',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.errorText,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AppDropdownModalSheet extends StatefulWidget {
  final String title;
  final String? selectedValue;
  final List<String> options;
  final bool enableSearch;
  final ValueChanged<String> onSelected;

  const _AppDropdownModalSheet({
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.enableSearch,
    required this.onSelected,
  });

  @override
  State<_AppDropdownModalSheet> createState() => _AppDropdownModalSheetState();
}

class _AppDropdownModalSheetState extends State<_AppDropdownModalSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _filteredOptions;

  @override
  void initState() {
    super.initState();
    _filteredOptions = List.from(widget.options);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredOptions = List.from(widget.options);
      } else {
        _filteredOptions = widget.options
            .where((opt) => opt.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSearchable = widget.enableSearch;

    return Container(
      height: 85.h,
      constraints: BoxConstraints(maxHeight: 85.h),
      decoration: const BoxDecoration(
        color: AppColors.modalBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            mainAxisSize: .max,
            children: [
              // Handle bar indicator
              Container(
                width: 10.w,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 1.5.h),

              // Modal Header
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: .bold,
                      ),
                      overflow: .ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: AppIcons.cancel(size: 18, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 1.h),

              // Optional Search Field
              if (isSearchable) ...[
                TextField(
                  controller: _searchController,
                  onChanged: _filter,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: "Rechercher...",
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: AppIcons.search(
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.card,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.2.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.circular12,
                      borderSide: const BorderSide(
                        color: AppColors.borderSubtle,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.circular12,
                      borderSide: const BorderSide(
                        color: AppColors.skyBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.5.h),
              ],

              // Options List
              Expanded(child: _buildOptionsListView(primary: false)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsListView({required bool primary}) {
    if (_filteredOptions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          child: Text(
            "Aucun résultat trouvé",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      primary: primary,
      itemCount: _filteredOptions.length,
      separatorBuilder: (context, index) =>
          const Divider(color: AppColors.borderSubtle, height: 1),
      itemBuilder: (context, index) {
        final item = _filteredOptions[index];
        final isSelected = item == widget.selectedValue;

        return InkWell(
          onTap: () {
            widget.onSelected(item);
            Navigator.pop(context);
          },
          borderRadius: AppRadius.circular8,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.8.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.skyBlue.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: AppRadius.circular8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected
                          ? AppColors.skyBlue
                          : AppColors.textPrimary,
                      fontWeight: isSelected ? .bold : .normal,
                    ),
                  ),
                ),
                if (isSelected)
                  AppIcons.check(color: AppColors.skyBlue, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
