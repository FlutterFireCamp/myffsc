import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/test_quiz_entity.dart';
import '../widgets/quiz_option_tile.dart';
import '../widgets/quiz_segmented_progress_bar.dart';

class TestTakingPage extends StatefulWidget {
  final TestQuizEntity quiz;

  const TestTakingPage({super.key, required this.quiz});

  @override
  State<TestTakingPage> createState() => _TestTakingPageState();
}

class _TestTakingPageState extends State<TestTakingPage> {
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _isSubmitted = false;

  late int _remainingSeconds;
  Timer? _timer;

  final TextEditingController _textAnswerController = TextEditingController();
  final Map<int, dynamic> _userAnswers = {};

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.quiz.totalDurationMinutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _showTimeUpDialog();
      }
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.modalBackground,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.circular16),
        title: Text(
          "Temps Écoule !",
          style: AppTextStyles.h3.copyWith(color: AppColors.errorText),
        ),
        content: Text(
          "Le temps imparti pour cet examen est terminé. Vos réponses actuelles vont être soumises.",
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // leave quiz
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.actionBlue),
            child: const Text("Terminer"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textAnswerController.dispose();
    super.dispose();
  }

  String _formatTimer(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  void _onNextOrSubmit() {
    if (!_isSubmitted) {
      setState(() {
        _isSubmitted = true;
        _userAnswers[_currentQuestionIndex] = _selectedOptionIndex ?? _textAnswerController.text;
      });
    } else {
      if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedOptionIndex = null;
          _textAnswerController.clear();
          _isSubmitted = false;
        });
      } else {
        _finishQuiz();
      }
    }
  }

  void _finishQuiz() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.modalBackground,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.circular16),
        title: Text(
          "Examen Terminé",
          style: AppTextStyles.h3.copyWith(color: AppColors.correctText),
        ),
        content: Text(
          "Félicitations ! Vos réponses ont été transmises avec succès à l'équipe.",
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // leave test page
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.actionBlue),
            child: const Text("Retour aux tests"),
          ),
        ],
      ),
    );
  }

  void _showQuitConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.modalBackground,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.circular16),
        title: Text(
          "Quitter l'examen ?",
          style: AppTextStyles.h3.copyWith(color: AppColors.alertRed),
        ),
        content: Text(
          "Si vous quittez maintenant, l'examen sera interrompu et vos réponses actuelles seront enregistrées définitivement.",
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Continuer l'examen"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // leave test page
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.incorrectBorder),
            child: const Text("Quitter"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentQuestionIndex];
    final totalQuestions = widget.quiz.questions.length;
    final isChoiceQuestion = question.type == 'choice';
    final options = question.options ?? [];

    return SensitiveContent(
      sensitivity: ContentSensitivity.sensitive,
      child: SelectionContainer.disabled(
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: AppIcons.cancel(color: AppColors.textSecondary, size: 20),
              onPressed: _showQuitConfirmDialog,
            ),
            title: Text(
              widget.quiz.title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: Row(
                  children: [
                    AppIcons.forms(size: 16, color: AppColors.textMuted),
                    SizedBox(width: 1.w),
                    Text(
                      "Text view",
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 1.h),

                // Timer & Segmented Progress Bar Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Timer Pill
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                            decoration: BoxDecoration(
                              color: AppColors.ultraDark,
                              borderRadius: AppRadius.circular8,
                              border: Border.all(
                                color: _remainingSeconds < 120
                                    ? AppColors.alertRed
                                    : AppColors.borderSubtle,
                              ),
                            ),
                            child: Row(
                              children: [
                                AppIcons.timer(
                                  size: 16,
                                  color: _remainingSeconds < 120
                                      ? AppColors.alertRed
                                      : AppColors.skyBlue,
                                ),
                                SizedBox(width: 1.5.w),
                                Text(
                                  _formatTimer(_remainingSeconds),
                                  style: AppTextStyles.caption.copyWith(
                                    color: _remainingSeconds < 120
                                        ? AppColors.alertRed
                                        : AppColors.skyBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            "${_currentQuestionIndex + 1} / $totalQuestions",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),

                      // Segmented Progress Bar Widget
                      QuizSegmentedProgressBar(
                        total: totalQuestions,
                        currentIndex: _currentQuestionIndex,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Question Title & Answers Area
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_currentQuestionIndex + 1}. ${question.title}",
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.35,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Options List (or Text Field if essay/open question)
                        if (isChoiceQuestion)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: options.length,
                            separatorBuilder: (context, index) => SizedBox(height: 1.8.h),
                            itemBuilder: (context, index) {
                              final isSelected = _selectedOptionIndex == index;
                              final isCorrect = question.correctAnswers?.contains(index) ?? false;

                              return QuizOptionTile(
                                index: index,
                                optionText: options[index],
                                isSelected: isSelected,
                                isSubmitted: _isSubmitted,
                                isCorrect: isCorrect,
                                onTap: () {
                                  setState(() {
                                    _selectedOptionIndex = index;
                                  });
                                },
                              );
                            },
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _textAnswerController,
                                enabled: !_isSubmitted,
                                maxLines: 5,
                                enableInteractiveSelection: false,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                                decoration: InputDecoration(
                                  hintText: "Saisissez votre réponse ici...",
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                                  filled: true,
                                  fillColor: AppColors.card,
                                  border: OutlineInputBorder(
                                    borderRadius: AppRadius.circular12,
                                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: AppRadius.circular12,
                                    borderSide: const BorderSide(color: AppColors.actionBlue, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 3.h),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
                  decoration: const BoxDecoration(
                    color: AppColors.card,
                    border: Border(
                      top: BorderSide(color: AppColors.borderSubtle, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isSubmitted ? "Réponse enregistrée" : "Sélectionnez une réponse",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: (_selectedOptionIndex == null &&
                                (isChoiceQuestion || _textAnswerController.text.trim().isEmpty))
                            ? null
                            : _onNextOrSubmit,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
                          backgroundColor: const Color(0xFF2563EB),
                          disabledBackgroundColor: AppColors.cardHover,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          !_isSubmitted
                              ? "Valider"
                              : (_currentQuestionIndex < totalQuestions - 1 ? "Next" : "Terminer"),
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
