import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';

/// Helper centralisé pour la manipulation et la conversion des dates.
/// IMPORTANT : Toutes les dates dans Firestore proviennent en UTC (GMT 0).
/// Cette classe garantit la conversion systématique vers le fuseau horaire local du smartphone.
class DateTimeHelper {
  const DateTimeHelper._();

  /// Convertit n'importe quelle valeur brute Firestore (Timestamp, String ISO, DD/MM/YYYY, etc.)
  /// en un objet [DateTime] strictement configuré à l'heure locale du device (.toLocal()).
  static DateTime? parseToLocal(dynamic rawDate) {
    if (rawDate == null) return null;

    try {
      if (rawDate is Timestamp) {
        return rawDate.toDate().toLocal();
      }

      if (rawDate is DateTime) {
        return rawDate.toLocal();
      }

      if (rawDate is String) {
        final str = rawDate.trim();
        if (str.isEmpty) return null;

        // 1. Essai de parsing ISO-8601 (ex: "2026-08-18T14:30:00Z" ou "2026-08-18T14:30:00")
        final parsedIso = DateTime.tryParse(str);
        if (parsedIso != null) {
          // Si la chaîne n'avait pas de suffixe 'Z' ou offset, on s'assure de l'interpréter en UTC
          // avant de convertir en heure locale du device.
          if (!str.endsWith('Z') && !str.contains('+') && !str.contains('-', 10)) {
            final utcDate = DateTime.utc(
              parsedIso.year,
              parsedIso.month,
              parsedIso.day,
              parsedIso.hour,
              parsedIso.minute,
              parsedIso.second,
              parsedIso.millisecond,
            );
            return utcDate.toLocal();
          }
          return parsedIso.toLocal();
        }

        // 2. Format personnalisé YYYY-MM-DD ou DD/MM/YYYY
        final parts = str.split(RegExp(r'[-/.]'));
        if (parts.length >= 3) {
          int? y, m, d;
          if (parts[0].length == 4) {
            // YYYY-MM-DD
            y = int.tryParse(parts[0]);
            m = int.tryParse(parts[1]);
            d = int.tryParse(parts[2]);
          } else {
            // DD-MM-YYYY
            d = int.tryParse(parts[0]);
            m = int.tryParse(parts[1]);
            y = int.tryParse(parts[2]);
          }

          if (y != null && m != null && d != null) {
            return DateTime.utc(y, m, d).toLocal();
          }
        }
      }
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors du parsing de la date brute: "$rawDate"',
        name: 'DATE_TIME_HELPER',
        error: e,
        stackTrace: stackTrace,
      );
    }

    return null;
  }

  /// Vérifie si la date spécifiée correspond à aujourd'hui dans le fuseau local.
  static bool isToday(DateTime? dt) {
    if (dt == null) return false;
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  /// Vérifie si la date est passée par rapport à l'heure actuelle du device.
  static bool isPast(DateTime? dt) {
    if (dt == null) return false;
    return dt.isBefore(DateTime.now());
  }

  /// Retourne le nombre de minutes restantes avant la date (négatif si passée).
  static int minutesUntil(DateTime dt) {
    return dt.difference(DateTime.now()).inMinutes;
  }

  /// Formate une date en chaîne lisible locale (ex: "18 août 2026").
  static String formatFrenchDate(DateTime dt) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    final monthName = months[dt.month - 1];
    return "${dt.day} $monthName ${dt.year}";
  }

  /// Formate l'heure locale en HH:mm (ex: "14h30" ou "09:00").
  static String formatLocalTime(DateTime dt, {bool withSuffix = true}) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return withSuffix ? "${hour}h$minute" : "$hour:$minute";
  }

  /// Formate la date au format standardisé YYYY-MM-DD.
  static String formatYmd(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }
}
