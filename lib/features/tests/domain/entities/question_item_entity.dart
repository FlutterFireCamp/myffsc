import 'package:equatable/equatable.dart';

class QuestionItemEntity extends Equatable {
  final String id;
  final String title;
  final String? statement;
  final String type; // 'choice' | 'text' | 'open'
  final int level;
  final List<int> modules;
  final int points;
  final int? timingSeconds;
  final List<String>? options;
  final List<int>? correctAnswers;
  final List<String>? optionExplanations;
  final String? expectedText;
  final String? explanation;
  final String? createdAt;
  final String? updatedAt;

  const QuestionItemEntity({
    required this.id,
    required this.title,
    this.statement,
    required this.type,
    required this.level,
    required this.modules,
    required this.points,
    this.timingSeconds,
    this.options,
    this.correctAnswers,
    this.optionExplanations,
    this.expectedText,
    this.explanation,
    this.createdAt,
    this.updatedAt,
  });

  String get displayStatement {
    if (statement != null && statement!.trim().isNotEmpty) {
      return statement!.trim();
    }
    return title.trim();
  }

  bool get isChoice =>
      type.toLowerCase() == 'choice' ||
      type.toLowerCase() == 'qcm' ||
      type.toLowerCase() == 'multiple' ||
      type.toLowerCase() == 'single' ||
      type.toLowerCase() == 'choix' ||
      (options != null && options!.isNotEmpty);

  int get actualPoints => points > 0 ? points : 25;

  bool checkIsAnswerCorrect(dynamic userAnswer) {
    if (userAnswer == null) return false;

    final userAnsStr = userAnswer.toString().trim();
    if (userAnsStr.isEmpty || userAnsStr == '-1') return false;

    final userAnsLower = userAnsStr.toLowerCase();
    final intAns = userAnswer is int ? userAnswer : int.tryParse(userAnsStr);

    // If expectedText is provided and non-empty, use it as a primary reference
    if (expectedText != null && expectedText!.trim().isNotEmpty) {
      final expLower = expectedText!.trim().toLowerCase();
      if (userAnsLower == expLower) return true;

      // If user provided an index, check if that option matches expectedText
      if (intAns != null &&
          options != null &&
          intAns >= 0 &&
          intAns < options!.length) {
        if (options![intAns].trim().toLowerCase() == expLower) {
          return true;
        }
      }

      // If expectedText matches an option, find its canonical 0-based index
      if (options != null) {
        final expectedIdx = options!
            .indexWhere((opt) => opt.trim().toLowerCase() == expLower);
        if (expectedIdx != -1) {
          if (intAns != null && intAns == expectedIdx) return true;
          // Check letter 'A' -> 0, 'B' -> 1
          if (userAnsStr.length == 1 && RegExp(r'[A-Za-z]').hasMatch(userAnsStr)) {
            final letterIdx = userAnsStr.toUpperCase().codeUnitAt(0) - 65;
            if (letterIdx == expectedIdx) return true;
          }
          return false;
        }
      }
    }

    if (correctAnswers == null || correctAnswers!.isEmpty) {
      return false;
    }

    // Determine 0-based correct indices
    final bool isDefinitelyOneBased =
        options != null && correctAnswers!.any((c) => c >= options!.length);
    final Set<int> zeroBasedCorrectIndices = {};

    for (final c in correctAnswers!) {
      if (isDefinitelyOneBased) {
        zeroBasedCorrectIndices.add(c - 1);
      } else {
        zeroBasedCorrectIndices.add(c);
      }
    }

    // 1. Check numeric index
    if (intAns != null) {
      if (zeroBasedCorrectIndices.contains(intAns)) return true;
      if (correctAnswers!.contains(intAns)) return true;
    }

    // 2. Check letter ('A', 'B', 'C', 'D')
    if (userAnsStr.length == 1 && RegExp(r'[A-Za-z]').hasMatch(userAnsStr)) {
      final letterIdx = userAnsStr.toUpperCase().codeUnitAt(0) - 65;
      if (zeroBasedCorrectIndices.contains(letterIdx)) return true;
    }

    // 3. Check option text
    if (options != null) {
      for (final idx in zeroBasedCorrectIndices) {
        if (idx >= 0 && idx < options!.length) {
          if (options![idx].trim().toLowerCase() == userAnsLower) {
            return true;
          }
        }
      }
    }

    return false;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        statement,
        type,
        level,
        modules,
        points,
        timingSeconds,
        options,
        correctAnswers,
        optionExplanations,
        expectedText,
        explanation,
        createdAt,
        updatedAt,
      ];
}
