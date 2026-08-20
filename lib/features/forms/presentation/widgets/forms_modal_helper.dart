import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';

class FormsModalHelper {
  static const String ideaUrl = 'https://forms.gle/6tQUJwNjN3ma8q6a6';
  static const String feedbackUrl = 'https://forms.gle/m1ndUV3y9x7QLFfGA';
  static const String reportUrl = 'https://forms.gle/uPNdw1pbjbiyJQZn9';

  static String getCertificateUrl(int level) {
    switch (level) {
      case 2:
        return 'https://forms.gle/AdWZ9wH3p47TKoCZA';
      case 3:
        return 'https://forms.gle/DsYnpfwmNCasyoHU6';
      case 1:
      default:
        return 'https://forms.gle/MVqJE5EXkg4HsUrP9';
    }
  }

  static String getCertificateTitle(int level) {
    switch (level) {
      case 2:
        return 'Certificat Flutter (Niveau 2)';
      case 3:
        return 'Certificat Firebase (Niveau 3)';
      case 1:
      default:
        return 'Certificat Dart (Niveau 1)';
    }
  }

  static String getCertificateSubtitle(int level) {
    switch (level) {
      case 2:
        return 'Soumettez votre projet Flutter pour valider le Niveau 2';
      case 3:
        return 'Soumettez votre projet Firebase pour valider le Niveau 3';
      case 1:
      default:
        return 'Soumettez votre projet Dart pour valider le Niveau 1';
    }
  }

  static Future<void> openUrl(BuildContext context, String urlString) async {
    final isOnline = await NetworkHelper.checkConnection(context);
    if (!isOnline) return;

    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: .externalApplication)) {
        if (context.mounted) {
          AppSnackBar.showError(
            context,
            "Impossible d'ouvrir le formulaire : $urlString",
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showError(context, "Erreur lors de l'ouverture : $e");
      }
    }
  }

  static void openFeedbackForm(BuildContext context) {
    openUrl(context, feedbackUrl);
  }

  static void openReportForm(BuildContext context) {
    openUrl(context, reportUrl);
  }

  static void openIdeaForm(BuildContext context) {
    openUrl(context, ideaUrl);
  }

  static void openCertificateForm(BuildContext context, int level) {
    openUrl(context, getCertificateUrl(level));
  }
}
