import 'dart:developer' as dev;
import 'package:firebase_analytics/firebase_analytics.dart';

/// Service centralisé pour le suivi analytique Firebase et les événements personnalisés.
class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  /// Retourne l'observateur pour GoRouter et le Navigator.
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Enregistre un événement personnalisé.
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
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
    try {
      await _analytics.logScreenView(
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
    try {
      await _analytics.setUserId(id: userId);
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
    try {
      await _analytics.setUserProperty(name: name, value: value);
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
    try {
      await _analytics.logLogin(loginMethod: loginMethod);
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
