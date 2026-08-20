import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Arrière-plans & Cartes (Fond Sombre Immersif & 100% Opaque)
  static const Color background = Color(0xFF070A13);
  static const Color ultraDark = Color(0xFF04050A);
  static const Color modalBackground = Color(0xFF0F172A); // Slate 900
  static const Color card = Color(0xFF0F172A); // Slate 900
  static const Color cardHover = Color(0xFF1E293B); // Slate 800
  static const Color borderSubtle = Color.fromRGBO(255, 255, 255, 0.12);
  static const Color borderMedium = Color(0xFF334155);

  // Surfaces, Modales & Conteneurs Quiz
  static const Color navySurface = Color(0xFF131D33);
  static const Color navyDarkSurface = Color(0xFF111D30);
  static const Color navyCard = Color(0xFF162238);
  static const Color navyBorder = Color(0xFF223554);
  static const Color navyBorderSubtle = Color(0xFF1E2D4A);
  static const Color codeBackground = Color(0xFF0D1424);
  static const Color codeHighlightBg = Color(0xFF1E293B);

  // SnackBars
  static const Color snackBarError = Color(0xFF7F1D1D); // Dark Red
  static const Color snackBarSuccess = Color(0xFF1E293B); // Dark Slate

  // Les Bleus (Accents Flutter & Thème Principal)
  static const Color flutterBlue = Color(0xFF02569B);
  static const Color flutterLightBlue = Color(0xFF0288D1);
  static const Color skyBlue = Color(0xFF38BDF8); // Sky 400
  static const Color actionBlue = Color(0xFF38BDF8); // Sky 400 (Remis en skyBlue)

  // Podium & Médailles
  static const Color gold = Color(0xFFFBBF24); // Gold / Amber #FBBF24
  static const Color silver = Color(0xFF94A3B8); // Silver / Slate 400 #94A3B8
  static const Color bronze = Color(0xFFD97706); // Bronze / Amber 600 #D97706
  static const Color goldSurface = Color(0xFF18181B);
  static const Color silverSurface = Color(0xFF161F2E);

  // Les Jaunes & Oranges (Accents Firebase & Compteurs)
  static const Color firebaseOrange = Color(0xFFF57C00);
  static const Color firebaseYellow = Color(0xFFFFCA28);
  static const Color warningAmber = gold;
  static const Color ideaAmber = Color(0xFFFFB703);

  // Les Verts (Succès & Attestations)
  static const Color correctContainer = Color(0xFF0F3818);
  static const Color correctBorder = Color(0xFF16A34A);
  static const Color correctText = Color(0xFF4ADE80); // #4ADE80
  static const Color successGreen = Color(0xFF22C55E);
  static const Color certificateGreen = Color(0xFF10B981);
  static const Color correctContainerDark = Color(0xFF102D24);
  static const Color correctBorderDark = Color(0xFF23855E);
  static const Color correctBar = Color(0xFF30A46C);
  static const Color correctBoxBg = Color(0xFF0E2824);
  static const Color correctCodeBg = Color(0xFF162923);

  // Les Rouges & Violets (Erreurs, Alertes & Conférences)
  static const Color incorrectContainer = Color(0xFF3F1214);
  static const Color incorrectBorder = Color(0xFFDC2626);
  static const Color errorText = Color(0xFFEF4444);
  static const Color alertRed = Color(0xFFF87171); // #F87171
  static const Color purpleConference = Color(0xFFC084FC); // #C084FC
  static const Color incorrectContainerDark = Color(0xFF331622);
  static const Color incorrectBorderDark = Color(0xFF8E283E);
  static const Color incorrectLight = Color(0xFFFF6B81);
  static const Color incorrectContainerAlt = Color(0xFF2B1624);
  static const Color incorrectBar = Color(0xFFE5484D);
  static const Color incorrectLabel = Color(0xFFFF8595);

  // Niveaux & Gradients
  static const Color level1DarkBlue = Color(0xFF013A63);
  static const Color level2Cyan = Color(0xFF01B5F8);
  static const Color level3Amber = Color(0xFFFF8F00);
  static const Color level3Orange = Color(0xFFFF6F00);
  static const Color level4LightBlue = Color(0xFF00C6FF);
  static const Color level4DeepBlue = Color(0xFF0072FF);
  static const Color progressBarGlow = Color(0xFFE0F2FE);

  static Color getLevelColor(int level) {
    switch (level) {
      case 1:
        return skyBlue;
      case 2:
        return actionBlue;
      case 3:
        return warningAmber;
      case 4:
      default:
        return purpleConference;
    }
  }

  // Unauthorized Page Colors
  static const Color unauthorizedBg = Color(0xFF1E1B4B);
  static const Color unauthorizedText = Color(0xFFA5B4FC);

  // PROGRAMMES (Agenda) Palette Exacte
  static const Color programWorkshopBadge = correctText;
  static const Color programWorkshopBadgeBg = Color.fromRGBO(34, 197, 94, 0.15);
  static const Color programWorkshopBorder = Color.fromRGBO(34, 197, 94, 0.30);
  static const Color programWorkshopBg = Color.fromRGBO(34, 197, 94, 0.08);

  static const Color programSessionBadge = skyBlue;
  static const Color programSessionBadgeBg = Color.fromRGBO(56, 189, 248, 0.15);
  static const Color programSessionBorder = Color.fromRGBO(56, 189, 248, 0.30);
  static const Color programSessionBg = Color.fromRGBO(56, 189, 248, 0.08);

  static const Color programConferenceBadge = purpleConference;
  static const Color programConferenceBadgeBg = Color.fromRGBO(168, 85, 247, 0.15);
  static const Color programConferenceBorder = Color.fromRGBO(168, 85, 247, 0.30);
  static const Color programConferenceBg = Color.fromRGBO(168, 85, 247, 0.08);

  static const Color programTestBadge = gold;
  static const Color programTestBadgeBg = Color.fromRGBO(251, 191, 36, 0.15);
  static const Color programTestBorder = Color.fromRGBO(251, 191, 36, 0.30);
  static const Color programTestBg = Color.fromRGBO(245, 158, 11, 0.08);

  // ANNONCES Palette Exacte
  static const Color announcementInfoColor = skyBlue;
  static const Color announcementInfoBadgeBg = Color.fromRGBO(56, 189, 248, 0.12);
  static const Color announcementInfoBorder = Color.fromRGBO(56, 189, 248, 0.30);
  static const Color announcementInfoCardBg = Color.fromRGBO(56, 189, 248, 0.06);

  static const Color announcementImportantColor = gold;
  static const Color announcementImportantBadgeBg = Color.fromRGBO(245, 158, 11, 0.12);
  static const Color announcementImportantBorder = Color.fromRGBO(245, 158, 11, 0.30);
  static const Color announcementImportantCardBg = Color.fromRGBO(245, 158, 11, 0.06);

  static const Color announcementUrgentColor = alertRed;
  static const Color announcementUrgentBadgeBg = Color.fromRGBO(239, 68, 68, 0.12);
  static const Color announcementUrgentBorder = Color.fromRGBO(239, 68, 68, 0.30);
  static const Color announcementUrgentCardBg = Color.fromRGBO(239, 68, 68, 0.06);

  // Textes Typographiques (Contrastes Clairs & Lisibles)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = silver;
}
