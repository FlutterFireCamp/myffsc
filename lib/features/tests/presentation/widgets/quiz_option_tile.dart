import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class QuizOptionTile extends StatelessWidget {
  final int index;
  final String optionText;
  final bool isSelected;
  final bool isSubmitted;
  final bool isCorrect;
  final VoidCallback onTap;

  const QuizOptionTile({
    super.key,
    required this.index,
    required this.optionText,
    required this.isSelected,
    required this.isSubmitted,
    required this.isCorrect,
    required this.onTap,
  });

  String get letterPrefix {
    const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    if (index >= 0 && index < letters.length) {
      return letters[index];
    }
    return '${index + 1}';
  }

  @override
  Widget build(BuildContext context) {
    Color optionBg = AppColors.card;
    Color optionBorder = AppColors.borderSubtle;
    Color textColor = AppColors.textPrimary;
    Color prefixColor = AppColors.textSecondary;

    if (isSubmitted) {
      if (isCorrect) {
        optionBg = AppColors.correctContainer;
        optionBorder = AppColors.correctBorder;
        textColor = AppColors.textPrimary;
        prefixColor = AppColors.correctText;
      } else if (isSelected && !isCorrect) {
        optionBg = AppColors.incorrectContainer;
        optionBorder = AppColors.incorrectBorder;
        textColor = AppColors.errorText;
        prefixColor = AppColors.errorText;
      }
    } else if (isSelected) {
      optionBg = AppColors.cardHover;
      optionBorder = AppColors.skyBlue;
      prefixColor = AppColors.skyBlue;
    }

    return InkWell(
      onTap: isSubmitted ? null : onTap,
      borderRadius: AppRadius.circular12,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: optionBg,
          borderRadius: AppRadius.circular12,
          border: Border.all(
            color: optionBorder,
            width: isSelected || (isSubmitted && isCorrect) ? 1.8 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: .center,
          children: [
            Text(
              "$letterPrefix. ",
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: .bold,
                color: prefixColor,
              ),
            ),
            Expanded(
              child: Text(
                optionText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: isSelected || (isSubmitted && isCorrect)
                      ? .w600
                      : .normal,
                ),
              ),
            ),
            if (isSubmitted && isCorrect) ...[
              SizedBox(width: 2.w),
              AppIcons.check(color: AppColors.correctText, size: 20),
            ] else if (isSubmitted && isSelected && !isCorrect) ...[
              SizedBox(width: 2.w),
              AppIcons.cancel(color: AppColors.errorText, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
