import 'package:flutter/material.dart';

class AppColors {
  // Arrière-plans & Cartes (Fond Sombre Immersif)
  static const Color background = Color(0xFF070A13);
  static const Color ultraDark = Color(0xFF04050A);
  static const Color card = Color.fromRGBO(15, 23, 42, 0.45); // Slate 900 / 0.45
  static const Color cardHover = Color.fromRGBO(30, 41, 59, 0.65); // Slate 800 / 0.65
  static const Color borderSubtle = Color.fromRGBO(255, 255, 255, 0.06);

  // Les Bleus (Accents Flutter & Thème Principal)
  static const Color flutterBlue = Color(0xFF02569B);
  static const Color skyBlue = Color(0xFF38BDF8); // Sky 400
  static const Color actionBlue = Color(0xFF3B82F6); // Blue 500

  // Les Jaunes & Oranges (Accents Firebase & Compteurs)
  static const Color firebaseOrange = Color(0xFFF57C00);
  static const Color firebaseYellow = Color(0xFFFFCA28);
  static const Color warningAmber = Color(0xFFF59E0B);

  // Les Verts (Succès & Réponses Correctes)
  static const Color correctContainer = Color(0xFF0F3818);
  static const Color correctBorder = Color(0xFF16A34A); // Green 600
  static const Color correctText = Color(0xFF4ADE80); // Green 400
  static const Color successGreen = Color(0xFF22C55E);

  // Les Rouges (Erreurs, Alertes & Réponses Incorrectes)
  static const Color incorrectContainer = Color(0xFF3F1214);
  static const Color incorrectBorder = Color(0xFFDC2626); // Red 600
  static const Color errorText = Color(0xFFEF4444); // Red 500
  static const Color alertRed = Color(0xFFF87171); // Red 400

  // Textes Typographiques
  static const Color textPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color textMuted = Color(0xFF64748B); // Slate 500
}
