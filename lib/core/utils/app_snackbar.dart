import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppSnackBar {
  /// Displays an error SnackBar with high-contrast text and clean styling.
  static void showError(BuildContext context, String message) {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.incorrectBorder, width: 1.2),
        ),
        backgroundColor: AppColors.incorrectContainer,
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.errorText,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _sanitizeErrorMessage(message),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays a success SnackBar with high-contrast text and clean styling.
  static void showSuccess(BuildContext context, String message) {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.skyBlue.withValues(alpha: 0.4), width: 1.2),
        ),
        backgroundColor: AppColors.cardHover,
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.skyBlue,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays a network / offline warning SnackBar.
  static void showNetworkError(BuildContext context) {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.warningAmber.withValues(alpha: 0.5), width: 1.2),
        ),
        backgroundColor: AppColors.cardHover,
        content: Row(
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: AppColors.warningAmber,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Connexion Internet requise pour cette action.",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Transforms raw technical Firebase/System error strings into short, user-friendly messages.
  static String _sanitizeErrorMessage(String rawError) {
    final lower = rawError.toLowerCase();

    if (lower.contains('network') || lower.contains('socket') || lower.contains('connection')) {
      return "Problème de connexion. Veuillez vérifier votre réseau Internet.";
    }
    if (lower.contains('user-not-found') || lower.contains('wrong-password') || lower.contains('invalid-credential')) {
      return "Identifiants incorrects. Veuillez vérifier vos informations de connexion.";
    }
    if (lower.contains('permission-denied') || lower.contains('unauthorized')) {
      return "Accès non autorisé. Veuillez contacter l'administration du camp.";
    }
    if (lower.contains('too-many-requests')) {
      return "Trop de tentatives. Veuillez patienter quelques minutes avant de réessayer.";
    }
    if (lower.contains('configuration') || lower.contains('clientconfigurationerror')) {
      return "Un problème de configuration est survenu. Veuillez contacter le support.";
    }
    if (lower.contains('cancel') || lower.contains('annul')) {
      return "Connexion interrompue par l'utilisateur.";
    }

    // Clean up generic "Exception: ..." wrappers if present
    String cleaned = rawError.replaceAll(RegExp(r'^Exception:\s*'), '').trim();
    if (cleaned.length > 90) {
      return "Une erreur est survenue. Veuillez réessayer plus tard.";
    }
    return cleaned.isNotEmpty ? cleaned : "Une erreur inattendue est survenue.";
  }
}
