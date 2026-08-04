import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class QuizSegmentedProgressBar extends StatelessWidget {
  final int total;
  final int currentIndex;

  const QuizSegmentedProgressBar({
    super.key,
    required this.total,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final isPassed = index < currentIndex;
        final isCurrent = index == currentIndex;

        Color segmentColor = AppColors.cardHover;
        if (isPassed) {
          segmentColor = AppColors.actionBlue;
        } else if (isCurrent) {
          segmentColor = AppColors.skyBlue;
        }

        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 0.5.w),
            height: 4,
            decoration: BoxDecoration(
              color: segmentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
