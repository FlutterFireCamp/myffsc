import 'package:flutter/material.dart';

/// Centralized Border Radius Definitions.
class AppRadius {
  AppRadius._();

  static const double r6 = 6.0;
  static const double r8 = 8.0;
  static const double r10 = 10.0;
  static const double r12 = 12.0;
  static const double r14 = 14.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r28 = 28.0;
  static const double r32 = 32.0;
  static const double circular = 999.0;

  static const BorderRadius circular6 = BorderRadius.all(Radius.circular(r6));
  static const BorderRadius circular8 = BorderRadius.all(Radius.circular(r8));
  static const BorderRadius circular10 = BorderRadius.all(Radius.circular(r10));
  static const BorderRadius circular12 = BorderRadius.all(Radius.circular(r12));
  static const BorderRadius circular14 = BorderRadius.all(Radius.circular(r14));
  static const BorderRadius circular16 = BorderRadius.all(Radius.circular(r16));
  static const BorderRadius circular20 = BorderRadius.all(Radius.circular(r20));
  static const BorderRadius circular24 = BorderRadius.all(Radius.circular(r24));
  static const BorderRadius circular28 = BorderRadius.all(Radius.circular(r28));
  static const BorderRadius circular32 = BorderRadius.all(Radius.circular(r32));
  static const BorderRadius top28 = BorderRadius.vertical(top: Radius.circular(r28));
}

/// Centralized Icon and Spacing Sizes.
class AppSizes {
  AppSizes._();

  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 28.0;
}
