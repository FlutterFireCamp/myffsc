import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/question_item_entity.dart';
import '../../domain/entities/test_quiz_entity.dart';
import '../bloc/bloc.dart';
import '../widgets/quiz_option_tile.dart';
import '../widgets/quiz_segmented_progress_bar.dart';
import 'test_results_page.dart';

class TestTakingPage extends StatefulWidget {
  final TestQuizEntity quiz;

  const TestTakingPage({super.key, required this.quiz});

  @override
  State<TestTakingPage> createState() => _TestTakingPageState();
}

class _TestTakingPageState extends State<TestTakingPage>
    with WidgetsBindingObserver {
  final TextEditingController _textAnswerController = TextEditingController();
  bool _showHint = false;
  int? _selectedOptionIndex;
  bool _isAnswerSubmittedForCurrentQuestion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textAnswerController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive ||
        lifecycleState == AppLifecycleState.hidden) {
      final authState = context.read<AuthBloc>().state;
      final userId = authState is AuthenticatedState ? authState.user.id : '';

      if (userId.isNotEmpty) {
        context.read<TestBloc>().add(AppBackgroundSwitchedEvent(userId: userId));

        final currentSwitchCount =
            context.read<TestBloc>().state.tabSwitchCount + 1;

        if (mounted) {
          AppSnackBar.showError(
            context,
            "Avertissement Anti-Triche ! Sortie d'application ($currentSwitchCount/3). À 3 sorties, le test est automatiquement soumis.",
          );
        }
      }
    }
  }

  String _formatTimer(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  void _showQuitConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Continuer l'examen"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // close dialog
              final authState = context.read<AuthBloc>().state;
              final userId = authState is AuthenticatedState ? authState.user.id : '';
              context.read<TestBloc>().add(FinishQuizEvent(userId: userId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.incorrectBorder,
            ),
            child: const Text("Quitter & Soumettre"),
          ),
        ],
      ),
    );
  }

  void _handleNextOrSubmit(BuildContext context, TestState state, QuestionItemEntity question) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is AuthenticatedState ? authState.user.id : '';

    if (!_isAnswerSubmittedForCurrentQuestion) {
      // First click: Validate answer for current question
      setState(() {
        _isAnswerSubmittedForCurrentQuestion = true;
      });

      final answer = question.type == 'choice'
          ? _selectedOptionIndex
          : _textAnswerController.text.trim();

      context.read<TestBloc>().add(AnswerQuestionEvent(
            questionIndex: state.currentQuestionIndex,
            answer: answer,
          ));
    } else {
      // Second click: Advance to next question or finish
      setState(() {
        _selectedOptionIndex = null;
        _textAnswerController.clear();
        _showHint = false;
        _isAnswerSubmittedForCurrentQuestion = false;
      });

      if (state.currentQuestionIndex < widget.quiz.questions.length - 1) {
        context.read<TestBloc>().add(const NextQuestionEvent());
      } else {
        context.read<TestBloc>().add(FinishQuizEvent(userId: userId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestBloc, TestState>(
      listener: (context, state) {
        if (state.isQuizFinished) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TestResultsPage(
                quiz: widget.quiz,
                userAnswers: state.userAnswersMap,
                qcmScore: state.qcmScore,
                totalPossibleScore: state.totalPossibleScore,
                timeSpentSeconds: state.totalTimeSpentSeconds,
                tabSwitchCount: state.tabSwitchCount,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final totalQuestions = widget.quiz.questions.length;
        final currentIdx = state.currentQuestionIndex.clamp(0, totalQuestions - 1);
        final question = widget.quiz.questions[currentIdx];
        final isChoiceQuestion = question.type == 'choice';
        final options = question.options ?? [];

        return SelectionContainer.disabled(
          child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: IconButton(
                  icon: AppIcons.cancel(color: AppColors.textSecondary, size: 20),
                  onPressed: () => _showQuitConfirmDialog(context),
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
                    padding: EdgeInsets.only(right: 4.w),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppColors.actionBlue.withValues(alpha: 0.15),
                          borderRadius: AppRadius.circular8,
                          border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          "${question.points} Pts",
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.skyBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 1.h),

                    // Timer Header & Bonus Bank Pill
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Timer Pill with Warning state < 15s
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.5.w,
                                  vertical: 0.7.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.ultraDark,
                                  borderRadius: AppRadius.circular8,
                                  border: Border.all(
                                    color: state.remainingSeconds < 15
                                        ? AppColors.alertRed
                                        : AppColors.borderSubtle,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    AppIcons.timer(
                                      size: 16,
                                      color: state.remainingSeconds < 15
                                          ? AppColors.alertRed
                                          : AppColors.skyBlue,
                                    ),
                                    SizedBox(width: 1.5.w),
                                    Text(
                                      _formatTimer(state.remainingSeconds),
                                      style: AppTextStyles.caption.copyWith(
                                        color: state.remainingSeconds < 15
                                            ? AppColors.alertRed
                                            : AppColors.skyBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (state.bonusTimeBank > 0) ...[
                                      SizedBox(width: 2.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.8.w,
                                          vertical: 0.2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.correctContainer,
                                          borderRadius: AppRadius.circular6,
                                        ),
                                        child: Text(
                                          "+${state.bonusTimeBank}s bonus",
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.correctText,
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Question Counter Badge
                              Text(
                                "${currentIdx + 1} / $totalQuestions",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.5.h),

                          // Segmented Progress Bar with Ticks ✓ / ✕
                          QuizSegmentedProgressBar(
                            total: totalQuestions,
                            currentIndex: currentIdx,
                            questions: widget.quiz.questions,
                            userAnswers: state.userAnswersMap,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5.h),

                    // Main Question Card & Answers Area
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${currentIdx + 1}. ${question.title}",
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.35,
                              ),
                            ),
                            SizedBox(height: 2.5.h),

                            // QCM Choice Options or Code / Text Area
                            if (isChoiceQuestion)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: options.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 1.8.h),
                                itemBuilder: (context, index) {
                                  final isSelected = _selectedOptionIndex == index;
                                  final isCorrect = question.correctAnswers
                                          ?.contains(index) ??
                                      false;

                                  return QuizOptionTile(
                                    index: index,
                                    optionText: options[index],
                                    isSelected: isSelected,
                                    isSubmitted: _isAnswerSubmittedForCurrentQuestion,
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
                                  Container(
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.ultraDark,
                                      borderRadius: AppRadius.circular12,
                                      border: Border.all(color: AppColors.borderSubtle),
                                    ),
                                    child: Row(
                                      children: [
                                        AppIcons.forms(color: AppColors.skyBlue, size: 18),
                                        SizedBox(width: 2.w),
                                        Text(
                                          "Zone d'écriture Dart / Code",
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.skyBlue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1.2.h),
                                  TextField(
                                    controller: _textAnswerController,
                                    enabled: !_isAnswerSubmittedForCurrentQuestion,
                                    maxLines: 6,
                                    enableInteractiveSelection: false,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontFamily: 'monospace',
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          "Saisissez votre code Dart ou votre réponse rédigée ici...",
                                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.card,
                                      border: OutlineInputBorder(
                                        borderRadius: AppRadius.circular12,
                                        borderSide: const BorderSide(
                                            color: AppColors.borderSubtle),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: AppRadius.circular12,
                                        borderSide: const BorderSide(
                                          color: AppColors.actionBlue,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: 2.5.h),

                            // Indice / Hint Expandable Accordion Toggle
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _showHint = !_showHint;
                                });
                              },
                              borderRadius: AppRadius.circular12,
                              child: Container(
                                padding: EdgeInsets.all(3.5.w),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: AppRadius.circular12,
                                  border: Border.all(
                                    color: AppColors.skyBlue.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            AppIcons.info(
                                              color: AppColors.skyBlue,
                                              size: 18,
                                            ),
                                            SizedBox(width: 2.w),
                                            Text(
                                              "Besoin d'un indice ?",
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.skyBlue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          _showHint
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: AppColors.skyBlue,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    if (_showHint) ...[
                                      SizedBox(height: 1.2.h),
                                      const Divider(color: AppColors.borderSubtle),
                                      SizedBox(height: 0.8.h),
                                      Text(
                                        question.explanation ??
                                            "Lisez attentivement l'énoncé et appliquez les principes fondateurs de Dart & Flutter.",
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Action Bar
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.8.h,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.card,
                        border: Border(
                          top: BorderSide(
                            color: AppColors.borderSubtle,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isAnswerSubmittedForCurrentQuestion
                                ? "Réponse enregistrée ✓"
                                : (_selectedOptionIndex != null ||
                                        _textAnswerController.text.trim().isNotEmpty
                                    ? "Prêt à valider"
                                    : "Sélectionnez une réponse"),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: (_selectedOptionIndex == null &&
                                    (isChoiceQuestion ||
                                        _textAnswerController.text
                                            .trim()
                                            .isEmpty))
                                ? null
                                : () => _handleNextOrSubmit(
                                      context,
                                      state,
                                      question,
                                    ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 1.5.h,
                              ),
                              backgroundColor: AppColors.actionBlue,
                              disabledBackgroundColor: AppColors.cardHover,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              !_isAnswerSubmittedForCurrentQuestion
                                  ? "Valider"
                                  : (currentIdx < totalQuestions - 1
                                      ? "Suivant"
                                      : "Terminer"),
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
          );
        },
      );
  }
}
