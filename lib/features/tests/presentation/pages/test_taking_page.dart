import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/question_item_entity.dart';

class TestTakingPage extends StatefulWidget {
  final QuestionItemEntity question;

  const TestTakingPage({super.key, required this.question});

  @override
  State<TestTakingPage> createState() => _TestTakingPageState();
}

class _TestTakingPageState extends State<TestTakingPage> {
  int? _selectedOptionIndex;
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Évaluation en direct"),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: _isSubmitted ? 1.0 : 0.5,
              backgroundColor: AppColors.card,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.skyBlue),
            ),
            SizedBox(height: 2.h),

            Text(
              "Niveau ${widget.question.level} • ${widget.question.points} Points",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 10.sp,
                color: AppColors.skyBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.5.h),

            Text(
              widget.question.title,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 3.h),

            // Options List
            Expanded(
              child: ListView.separated(
                itemCount: options.length,
                separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
                itemBuilder: (context, index) {
                  final isSelected = _selectedOptionIndex == index;
                  final isCorrect = widget.question.correctAnswers?.contains(index) ?? false;

                  Color optionBorder = AppColors.borderSubtle;
                  Color optionBg = AppColors.card;

                  if (_isSubmitted) {
                    if (isCorrect) {
                      optionBorder = AppColors.correctBorder;
                      optionBg = AppColors.correctContainer;
                    } else if (isSelected && !isCorrect) {
                      optionBorder = AppColors.incorrectBorder;
                      optionBg = AppColors.incorrectContainer;
                    }
                  } else if (isSelected) {
                    optionBorder = AppColors.actionBlue;
                    optionBg = AppColors.actionBlue.withValues(alpha: 0.15);
                  }

                  return InkWell(
                    onTap: _isSubmitted
                        ? null
                        : () {
                            setState(() {
                              _selectedOptionIndex = index;
                            });
                          },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: optionBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: optionBorder, width: isSelected ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              options[index],
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 11.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (_isSubmitted && isCorrect)
                            const Icon(AppIcons.check, color: AppColors.correctText)
                          else if (_isSubmitted && isSelected && !isCorrect)
                            const Icon(AppIcons.cancel, color: AppColors.errorText),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_isSubmitted && widget.question.explanation != null) ...[
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.3)),
                ),
                child: Text(
                  "Explication : ${widget.question.explanation}",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedOptionIndex == null
                    ? null
                    : () {
                        setState(() {
                          _isSubmitted = true;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.correctText,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isSubmitted ? "Réponse validée" : "Valider la réponse",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
