import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/user_question_correction.dart';

class TestCorrectionBottomSheet extends StatefulWidget {
  final String quizTitle;
  final String dateFormatted;
  final int totalScore;
  final int totalPossibleScore;
  final String status;
  final List<UserQuestionCorrection>? initialQuestions;
  final Future<List<UserQuestionCorrection>>? questionsFuture;

  const TestCorrectionBottomSheet({
    super.key,
    required this.quizTitle,
    required this.dateFormatted,
    required this.totalScore,
    required this.totalPossibleScore,
    required this.status,
    this.initialQuestions,
    this.questionsFuture,
  });

  static Future<void> show(
    BuildContext context, {
    required String quizTitle,
    required String dateFormatted,
    required int totalScore,
    required int totalPossibleScore,
    required String status,
    List<UserQuestionCorrection>? questions,
    Future<List<UserQuestionCorrection>>? questionsFuture,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TestCorrectionBottomSheet(
        quizTitle: quizTitle,
        dateFormatted: dateFormatted,
        totalScore: totalScore,
        totalPossibleScore: totalPossibleScore,
        status: status,
        initialQuestions: questions,
        questionsFuture: questionsFuture,
      ),
    );
  }

  @override
  State<TestCorrectionBottomSheet> createState() =>
      _TestCorrectionBottomSheetState();
}

class _TestCorrectionBottomSheetState extends State<TestCorrectionBottomSheet> {
  List<UserQuestionCorrection>? _questions;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _questions = widget.initialQuestions;
    if (_questions == null && widget.questionsFuture != null) {
      _isLoading = true;
      _loadQuestions();
    }
  }

  Future<void> _loadQuestions() async {
    try {
      final loaded = await widget.questionsFuture!;
      if (mounted) {
        setState(() {
          _questions = loaded;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _questions = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = _questions ?? [];
    final isPending = widget.status == 'pending';

    final badgeLabel = isPending ? "En Attente" : "Corrigé";
    final badgeColor = isPending
        ? AppColors.firebaseYellow
        : AppColors.correctText;

    return Container(
      constraints: BoxConstraints(maxHeight: 85.h),
      decoration: const BoxDecoration(
        color: AppColors.modalBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 10.w,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 1.5.h),

          // Header Row: Title & Subtitle (Left) + Close Button (Right)
          Row(
            crossAxisAlignment: .start,
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 0.4.h,
                  children: [
                    Text(
                      "Résultats & Correction de Test",
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: .bold,
                      ),
                    ),
                    Text(
                      "${widget.quizTitle} • ${widget.dateFormatted}",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: .circular(20),
                child: Container(
                  padding: const .all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: .circle,
                  ),
                  child: AppIcons.cancel(size: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Hero Score Card
          Container(
            width: double.infinity,
            padding: .symmetric(vertical: 2.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.navyCard,
              borderRadius: AppRadius.circular16,
              border: .all(color: AppColors.navyBorder),
            ),
            child: Column(
              spacing: 0.6.h,
              children: [
                Text(
                  "${widget.totalScore} / ${widget.totalPossibleScore} pts",
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontWeight: .bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  badgeLabel,
                  style: AppTextStyles.bodySmall.copyWith(color: badgeColor),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Section Title
          Text(
            "Détail des réponses et correction",
            style: AppTextStyles.titleSmall.copyWith(
              color: Colors.white,
              fontWeight: .bold,
            ),
          ),
          SizedBox(height: 1.5.h),

          // Body: Loader or Questions List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        color: AppColors.actionBlue,
                      ),
                    ),
                  )
                : questions.isEmpty
                ? Center(
                    child: Text(
                      "Aucune question disponible pour cette évaluation.",
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: questions.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final q = questions[index];
                      return _buildQuestionCard(q);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(UserQuestionCorrection q) {
    final isCorrect = q.isCorrect;
    final earned = q.earnedScore;
    final max = q.maxScore;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.navySurface,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.navyBorderSubtle),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 1.h,
        children: [
          // Header Row: Question Index (Left) & Points Badge (Right)
          Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .center,
            children: [
              Text(
                "Question ${q.index + 1}",
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.actionBlue,
                  fontWeight: .bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.5.w,
                  vertical: 0.4.h,
                ),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.correctContainerDark
                      : AppColors.incorrectContainerDark,
                  borderRadius: AppRadius.circular8,
                  border: Border.all(
                    color: isCorrect
                        ? AppColors.correctBorderDark
                        : AppColors.incorrectBorderDark,
                  ),
                ),
                child: Text(
                  isCorrect ? "✓ $earned/$max pts" : "✕ $earned/$max pts",
                  style: AppTextStyles.caption.copyWith(
                    color: isCorrect
                        ? AppColors.correctText
                        : AppColors.incorrectLight,
                  ),
                ),
              ),
            ],
          ),
          // Statement in Markdown format
          MarkdownBody(
            data: q.displayStatement,
            styleSheet: MarkdownStyleSheet(
              p: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
              strong: const TextStyle(fontWeight: .bold, color: Colors.white),
              code: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10.sp,
                color: AppColors.actionBlue,
                backgroundColor: AppColors.codeHighlightBg,
              ),
              codeblockDecoration: BoxDecoration(
                color: AppColors.codeBackground,
                borderRadius: AppRadius.circular8,
                border: Border.all(color: AppColors.navyBorderSubtle),
              ),
            ),
          ),
          // User's Answer Box ("Votre réponse :")
          _buildUserAnswerBox(q),

          // Correct / Expected Answer Box
          _buildExpectedAnswerBox(q),

          // Optional Explanation Box
          if (q.explanation != null && q.explanation!.trim().isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppColors.navyDarkSurface,
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                  left: BorderSide(color: AppColors.actionBlue, width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 0.4.h,
                children: [
                  Text(
                    "Explication :",
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.actionBlue,
                      fontWeight: .bold,
                    ),
                  ),
                  MarkdownBody(
                    data: q.explanation!.trim(),
                    styleSheet: MarkdownStyleSheet(
                      p: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                        height: 1.35,
                      ),
                      code: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9.sp,
                        color: AppColors.actionBlue,
                        backgroundColor: AppColors.codeHighlightBg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserAnswerBox(UserQuestionCorrection q) {
    String answerText = "";
    final ans = q.studentAnswer;

    if (ans == null ||
        ans == -1 ||
        ans == "-1" ||
        ans.toString().trim().isEmpty) {
      answerText = "Aucune réponse fournie";
    } else if (q.isChoice) {
      final options = q.options ?? [];
      int? ansIndex;
      if (ans is int) {
        ansIndex = ans;
      } else if (ans is String) {
        ansIndex = int.tryParse(ans.trim());
      }

      if (ansIndex != null) {
        if (ansIndex >= 0 && ansIndex < options.length) {
          answerText = "${ansIndex + 1}. ${options[ansIndex]}";
        } else if (ansIndex >= 1 && ansIndex <= options.length) {
          answerText = "$ansIndex. ${options[ansIndex - 1]}";
        } else {
          answerText = "$ans";
        }
      } else {
        answerText = ans.toString();
      }
    } else {
      answerText = ans.toString().trim();
    }

    final isCorrect = q.isCorrect;
    final Color bgColor = isCorrect
        ? AppColors.correctContainerDark
        : AppColors.incorrectContainerAlt;
    final Color barColor = isCorrect
        ? AppColors.correctBar
        : AppColors.incorrectBar;
    final Color labelColor = isCorrect
        ? AppColors.correctText
        : AppColors.incorrectLabel;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: barColor, width: 3.5)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 0.6.h,
        children: [
          Text(
            "Votre réponse :",
            style: AppTextStyles.caption.copyWith(
              color: labelColor,
              fontWeight: .bold,
            ),
          ),
          MarkdownBody(
            data: answerText,
            styleSheet: MarkdownStyleSheet(
              p: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: .w500,
                height: 1.35,
              ),
              code: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9.5.sp,
                color: Colors.white,
                backgroundColor: AppColors.codeHighlightBg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpectedAnswerBox(UserQuestionCorrection q) {
    String correctText = "";
    final isChoice = q.isChoice;
    final options = q.options ?? [];

    if (isChoice) {
      if (q.correctAnswers != null && q.correctAnswers!.isNotEmpty) {
        final List<String> formatted = [];
        for (final ca in q.correctAnswers!) {
          if (ca >= 0 && ca < options.length) {
            formatted.add("${ca + 1}. ${options[ca]}");
          } else if (ca >= 1 && ca <= options.length) {
            formatted.add("$ca. ${options[ca - 1]}");
          } else {
            formatted.add("$ca");
          }
        }
        correctText = formatted.join("\nOU\n");
      } else if (q.expectedAnswer != null &&
          q.expectedAnswer.toString().trim().isNotEmpty) {
        correctText = q.expectedAnswer.toString().trim();
      } else if (options.isNotEmpty) {
        correctText = "1. ${options[0]}";
      }
    } else {
      // Open / text / code question
      if (q.expectedAnswer != null &&
          q.expectedAnswer.toString().trim().isNotEmpty) {
        correctText = q.expectedAnswer.toString().trim();
      } else if (q.explanation != null && q.explanation!.trim().isNotEmpty) {
        correctText = q.explanation!.trim();
      } else {
        correctText = "Réponse validée selon les critères du barème.";
      }
    }

    final boxTitle = isChoice
        ? "✓ Option correcte qu'il fallait cocher :"
        : "✓ Réponse attendue :";

    return Container(
      width: double.infinity,
      padding: .all(3.w),
      decoration: const BoxDecoration(
        color: AppColors.correctBoxBg,
        borderRadius: .all(Radius.circular(8)),
        border: Border(
          left: BorderSide(color: AppColors.correctBar, width: 3.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 0.6.h,
        children: [
          Text(
            boxTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.correctText,
              fontWeight: .bold,
            ),
          ),
          MarkdownBody(
            data: correctText,
            styleSheet: MarkdownStyleSheet(
              p: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: .w500,
                height: 1.35,
              ),
              code: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9.5.sp,
                color: AppColors.correctText,
                backgroundColor: AppColors.correctCodeBg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
