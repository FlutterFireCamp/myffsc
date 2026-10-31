import 'package:flutter_test/flutter_test.dart';
import 'package:myffsc/features/forms/presentation/widgets/forms_modal_helper.dart';

void main() {
  group('FormsModalHelper Tests', () {
    test('getVerificationUrl should format correctly with or without code', () {
      expect(
        FormsModalHelper.getVerificationUrl('FFC-2026-LRN-CUV7GL'),
        'https://www.flutterfirecamp.dev/verify/FFC-2026-LRN-CUV7GL',
      );
      expect(
        FormsModalHelper.getVerificationUrl(''),
        'https://www.flutterfirecamp.dev/verify/',
      );
      expect(
        FormsModalHelper.getVerificationUrl(null),
        'https://www.flutterfirecamp.dev/verify/',
      );
      expect(
        FormsModalHelper.getVerificationUrl('https://custom.domain.com/cert/123'),
        'https://custom.domain.com/cert/123',
      );
    });

    test('getCertificateTitle adapts when camp has ended', () {
      expect(
        FormsModalHelper.getCertificateTitle(1, isCampEnded: false),
        'Certificat Dart (Niveau 1)',
      );
      expect(
        FormsModalHelper.getCertificateTitle(1, isCampEnded: true),
        'Vérification de Certificat',
      );
    });

    test('getCertificateSubtitle adapts when camp has ended', () {
      expect(
        FormsModalHelper.getCertificateSubtitle(1, isCampEnded: false),
        'Soumettez votre projet Dart pour valider le Niveau 1',
      );
      expect(
        FormsModalHelper.getCertificateSubtitle(
          1,
          isCampEnded: true,
          certificateCode: 'FFC-2026-LRN-CUV7GL',
        ),
        contains('FFC-2026-LRN-CUV7GL'),
      );
      expect(
        FormsModalHelper.getCertificateSubtitle(1, isCampEnded: true),
        contains('portail de vérification'),
      );
    });
  });
}
