import 'package:flutter/material.dart';

class AppColors {
  // Arrière-plans & Cartes (Fond Sombre Immersif & 100% Opaque)
  static const Color background = Color(0xFF070A13);
  static const Color ultraDark = Color(0xFF04050A);
  static const Color modalBackground = Color(0xFF0F172A); // Slate 900
  static const Color card = Color(0xFF0F172A); // Slate 900
  static const Color cardHover = Color(0xFF1E293B); // Slate 800
  static const Color borderSubtle = Color.fromRGBO(255, 255, 255, 0.12);

  // SnackBars
  static const Color snackBarError = Color(0xFF7F1D1D); // Dark Red
  static const Color snackBarSuccess = Color(0xFF1E293B); // Dark Slate

  // Les Bleus (Accents Flutter & Thème Principal)
  static const Color flutterBlue = Color(0xFF02569B);
  static const Color flutterLightBlue = Color(0xFF0288D1);
  static const Color skyBlue = Color(0xFF38BDF8); // Sky 400
  static const Color actionBlue = Color(0xFF3B82F6); // Blue 500

  // Les Jaunes & Oranges (Accents Firebase & Compteurs)
  static const Color firebaseOrange = Color(0xFFF57C00);
  static const Color firebaseYellow = Color(0xFFFFCA28);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color ideaAmber = Color(0xFFFFB703);

  // Les Verts (Succès & Attestations)
  static const Color correctContainer = Color(0xFF0F3818);
  static const Color correctBorder = Color(0xFF16A34A);
  static const Color correctText = Color(0xFF4ADE80);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color certificateGreen = Color(0xFF10B981);

  // Les Rouges & Violets (Erreurs, Alertes & Conférences)
  static const Color incorrectContainer = Color(0xFF3F1214);
  static const Color incorrectBorder = Color(0xFFDC2626);
  static const Color errorText = Color(0xFFEF4444);
  static const Color alertRed = Color(0xFFF87171);
  static const Color purpleConference = Color(0xFFC084FC);

  // Niveaux & Gradients
  static const Color level1DarkBlue = Color(0xFF013A63);
  static const Color level2Cyan = Color(0xFF01B5F8);
  static const Color level3Amber = Color(0xFFFF8F00);
  static const Color level3Orange = Color(0xFFFF6F00);
  static const Color level4LightBlue = Color(0xFF00C6FF);
  static const Color level4DeepBlue = Color(0xFF0072FF);
  static const Color progressBarGlow = Color(0xFFE0F2FE);

  // Unauthorized Page Colors
  static const Color unauthorizedBg = Color(0xFF1E1B4B);
  static const Color unauthorizedText = Color(0xFFA5B4FC);

  // Program Glassmorphic Graphic Palette Colors
  static const Color programSessionBadge = Color(0xFFFBBF24);
  static const Color programTestBadge = Color(0xFFF87171);
  static const Color programWorkshopBadge = Color(0xFF38BDF8);
  static const Color programConferenceBadge = Color(0xFFC084FC);
  static const Color programStudyGroupBadge = Color(0xFF4ADE80);

  static const Color programSessionBg = Color(0x14F59E0B);
  static const Color programTestBg = Color(0x14EF4444);
  static const Color programWorkshopBg = Color(0x1438BDF8);
  static const Color programConferenceBg = Color(0x14A855F7);
  static const Color programStudyGroupBg = Color(0x1422C55E);

  static const Color programSessionBorder = Color(0x40F59E0B);
  static const Color programTestBorder = Color(0x40EF4444);
  static const Color programWorkshopBorder = Color(0x4038BDF8);
  static const Color programConferenceBorder = Color(0x40A855F7);
  static const Color programStudyGroupBorder = Color(0x4022C55E);

  // Textes Typographiques (Contrastes Clairs & Lisibles)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF94A3B8);
}
