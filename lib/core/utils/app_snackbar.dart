import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppSnackBar {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: AppColors.snackBarError,
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _sanitizeErrorMessage(message),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: AppColors.snackBarSuccess,
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
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
