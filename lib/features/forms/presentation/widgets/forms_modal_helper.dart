import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';

class FormsModalHelper {
  static const String ideaUrl = 'https://forms.gle/6tQUJwNjN3ma8q6a6';
  static const String feedbackUrl =
      'https://docs.google.com/forms/d/e/1FAIpQLScu3r3O0sXE9Hz2CaZUKlW7-4P97pgUwX9KS9PGVihP8mcFIg/viewform';
  static const String reportUrl = 'https://forms.gle/uPNdw1pbjbiyJQZn9';
  static const String certificateVerificationBaseUrl =
      'https://www.flutterfirecamp.dev/verify/';

  // Cache mémoire des identifiants de certificats résolus pour éviter des requêtes répétées
  static final Map<String, String> _resolvedCertificatesCache = {};

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

  static String getCertificateTitle(int level, {bool isCampEnded = false}) {
    if (isCampEnded) {
      return 'Vérification de Certificat';
    }
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

  static String getCertificateSubtitle(
    int level, {
    bool isCampEnded = false,
    String? certificateCode,
  }) {
    if (isCampEnded) {
      if (certificateCode != null && certificateCode.trim().isNotEmpty) {
        return 'Consultez ou vérifiez votre certificat officiel : ${certificateCode.trim()}';
      }
      return 'Accédez au portail de vérification officiel pour consulter votre attestation.';
    }
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

  /// Résolution automatique et résiliente du code de certificat pour un utilisateur :
  /// 1. Vérifie si le UserEntity possède déjà le certificateCode
  /// 2. Vérifie le cache mémoire local
  /// 3. Interroge la collection Firestore 'certificates' par recipientUid (user.id)
  /// 4. Fallback : interroge la collection Firestore 'certificates' par recipientEmail (user.email)
  static Future<String?> resolveUserCertificateCode(UserEntity? user) async {
    if (user == null) return null;

    final existingCode = user.certificateCode?.trim();
    if (existingCode != null && existingCode.isNotEmpty) {
      _resolvedCertificatesCache[user.id] = existingCode;
      return existingCode;
    }

    if (_resolvedCertificatesCache.containsKey(user.id)) {
      return _resolvedCertificatesCache[user.id];
    }

    try {
      final firestore = sl<FirebaseFirestore>();

      // 1. Recherche directe par recipientUid
      final uidQuery = await firestore
          .collection('certificates')
          .where('recipientUid', isEqualTo: user.id)
          .limit(1)
          .get();

      if (uidQuery.docs.isNotEmpty) {
        final doc = uidQuery.docs.first;
        final data = doc.data();
        final certId = (data['certificateId'] ?? doc.id).toString();
        _resolvedCertificatesCache[user.id] = certId;
        dev.log('Certificat trouvé via recipientUid ($certId)', name: 'FORMS_MODAL_HELPER');
        return certId;
      }

      // 2. Recherche alternative par recipientEmail
      if (user.email.isNotEmpty) {
        final emailQuery = await firestore
            .collection('certificates')
            .where('recipientEmail', isEqualTo: user.email.trim().toLowerCase())
            .limit(1)
            .get();

        if (emailQuery.docs.isNotEmpty) {
          final doc = emailQuery.docs.first;
          final data = doc.data();
          final certId = (data['certificateId'] ?? doc.id).toString();
          _resolvedCertificatesCache[user.id] = certId;
          dev.log('Certificat trouvé via recipientEmail ($certId)', name: 'FORMS_MODAL_HELPER');
          return certId;
        }
      }
    } catch (e) {
      dev.log('Notice: résolution du certificat dans "certificates": $e', name: 'FORMS_MODAL_HELPER');
    }

    return null;
  }

  /// Construit l'URL de vérification selon le code du certificat
  static String getVerificationUrl(String? certificateCode) {
    final code = certificateCode?.trim();
    if (code != null && code.isNotEmpty) {
      if (code.startsWith('http://') || code.startsWith('https://')) {
        return code;
      }
      return 'https://www.flutterfirecamp.dev/verify/$code';
    }
    return certificateVerificationBaseUrl;
  }

  static Future<void> openUrl(BuildContext context, String urlString) async {
    final isOnline = await NetworkHelper.checkConnection(context);
    if (!isOnline) return;

    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          AppSnackBar.showError(
            context,
            "Impossible d'ouvrir le lien : $urlString",
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

  /// Ouvre directement la page de vérification du certificat (avec résolution dynamique)
  static Future<void> openCertificateVerification(
    BuildContext context, {
    UserEntity? user,
    String? certificateCode,
  }) async {
    String? code = certificateCode ?? user?.certificateCode;

    if ((code == null || code.trim().isEmpty) && user != null) {
      code = await resolveUserCertificateCode(user);
    }

    final url = getVerificationUrl(code);
    if (context.mounted) {
      await openUrl(context, url);
    }
  }

  /// Méthode adaptative : vérification si camp terminé, sinon formulaire Google
  static void openCertificateAction(
    BuildContext context, {
    required int level,
    UserEntity? user,
    bool isCampEnded = false,
  }) {
    if (isCampEnded) {
      openCertificateVerification(context, user: user);
    } else {
      openCertificateForm(context, level);
    }
  }
}
