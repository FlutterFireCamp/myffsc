import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/question_item_entity.dart';

class QuizSegmentedProgressBar extends StatelessWidget {
  final int total;
  final int currentIndex;
  final List<QuestionItemEntity> questions;
  final Map<int, dynamic> userAnswers;

  const QuizSegmentedProgressBar({
    super.key,
    required this.total,
    required this.currentIndex,
    required this.questions,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final isPassed = index < currentIndex;
        final isCurrent = index == currentIndex;
        final hasAnswered = userAnswers.containsKey(index);

        bool? isCorrectChoice;
        if (hasAnswered && index < questions.length) {
          final q = questions[index];
          if (q.type == 'choice' && q.correctAnswers != null) {
            isCorrectChoice = q.correctAnswers!.contains(userAnswers[index]);
          }
        }

        Color segmentColor = AppColors.cardHover;
        Widget? iconWidget;

        if (isPassed || hasAnswered) {
          if (isCorrectChoice == true) {
            segmentColor = AppColors.correctText; // #86efac
            iconWidget = const Icon(Icons.check, color: Colors.black, size: 10);
          } else if (isCorrectChoice == false) {
            segmentColor = AppColors.alertRed; // #fca5a5
            iconWidget = const Icon(Icons.close, color: Colors.white, size: 10);
          } else {
            segmentColor = AppColors.skyBlue;
          }
        } else if (isCurrent) {
          segmentColor = AppColors.skyBlue;
        }

        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 0.5.w),
            height: 6,
            decoration: BoxDecoration(
              color: segmentColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: iconWidget != null ? Center(child: iconWidget) : null,
          ),
        );
      }),
    );
  }
}
