import 'dart:developer' as dev;
import 'package:firebase_analytics/firebase_analytics.dart';

/// Service centralisé pour le suivi analytique Firebase et les événements personnalisés.
class AnalyticsService {
  final FirebaseAnalytics? analytics;
  final bool isAvailable;

  AnalyticsService({
    this.analytics,
    this.isAvailable = true,
  });

  /// Retourne l'observateur pour GoRouter et le Navigator de manière sécurisée.
  FirebaseAnalyticsObserver? get observer {
    if (!isAvailable || analytics == null) return null;
    try {
      return FirebaseAnalyticsObserver(analytics: analytics!);
    } catch (e) {
      dev.log('Impossible d’initialiser FirebaseAnalyticsObserver: $e', name: 'ANALYTICS_SERVICE');
      return null;
    }
  }

  /// Enregistre un événement personnalisé.
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!isAvailable || analytics == null) return;
    try {
      await analytics!.logEvent(
        name: name,
        parameters: parameters,
      );
      dev.log(
        'Événement Analytics consigné: $name | Paramètres: $parameters',
        name: 'ANALYTICS_SERVICE',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de l’envoi de l’événement "$name": $e',
        name: 'ANALYTICS_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Enregistre une vue d'écran manuelle si nécessaire.
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!isAvailable || analytics == null) return;
    try {
      await analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      dev.log(
        'Vue d’écran consignée: $screenName ($screenClass)',
        name: 'ANALYTICS_SERVICE',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la consignation de l’écran "$screenName": $e',
        name: 'ANALYTICS_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Associe l'identifiant de l'utilisateur connecté aux logs analytiques.
  Future<void> setUserId(String? userId) async {
    if (!isAvailable || analytics == null) return;
    try {
      await analytics!.setUserId(id: userId);
      dev.log('User ID Analytics défini: $userId', name: 'ANALYTICS_SERVICE');
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la définition du user ID Analytics: $e',
        name: 'ANALYTICS_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Définit une propriété utilisateur (ex: rôle, statut de profil, cohorte).
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (!isAvailable || analytics == null) return;
    try {
      await analytics!.setUserProperty(name: name, value: value);
      dev.log(
        'Propriété utilisateur définie: $name = $value',
        name: 'ANALYTICS_SERVICE',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la définition de la propriété utilisateur "$name": $e',
        name: 'ANALYTICS_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Enregistre la connexion d'un apprenant.
  Future<void> logLogin({String loginMethod = 'google'}) async {
    if (!isAvailable || analytics == null) return;
    try {
      await analytics!.logLogin(loginMethod: loginMethod);
      dev.log(
        'Connexion consignée via $loginMethod',
        name: 'ANALYTICS_SERVICE',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la consignation de connexion: $e',
        name: 'ANALYTICS_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Événement de démarrage d'un test / examen.
  Future<void> logTestStarted({
    required String testId,
    required String testTitle,
  }) async {
    await logEvent(
      name: 'test_started',
      parameters: {
        'test_id': testId,
        'test_title': testTitle,
      },
    );
  }

  /// Événement de soumission / fin d'un test.
  Future<void> logTestCompleted({
    required String testId,
    required String testTitle,
    required int score,
    required int totalQuestions,
  }) async {
    await logEvent(
      name: 'test_completed',
      parameters: {
        'test_id': testId,
        'test_title': testTitle,
        'score': score,
        'total_questions': totalQuestions,
      },
    );
  }

  /// Événement de soumission d'un formulaire.
  Future<void> logFormSubmitted({
    required String formId,
    required String formTitle,
  }) async {
    await logEvent(
      name: 'form_submitted',
      parameters: {
        'form_id': formId,
        'form_title': formTitle,
      },
    );
  }
}
