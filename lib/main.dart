import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'core/core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Verrouiller strictement l'orientation en mode portrait
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    dev.log('SystemChrome orientation lock error: $e', name: 'MAIN');
  }

  // 2. Initialiser Firebase Core
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e, stackTrace) {
    dev.log(
      'Firebase.initializeApp error: $e',
      name: 'MAIN',
      error: e,
      stackTrace: stackTrace,
    );
  }

  // 3. Configuration sécurisée de Firebase Crashlytics
  try {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    unawaited(FirebaseCrashlytics.instance.sendUnsentReports().catchError((e) {
      dev.log('Crashlytics sendUnsentReports notice: $e', name: 'MAIN');
    }));

    FlutterError.onError = (errorDetails) {
      try {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      } catch (_) {}
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      try {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } catch (_) {}
      return true;
    };
  } catch (e) {
    dev.log('Crashlytics initialization error: $e', name: 'MAIN');
  }

  // 4. Vérifier la disponibilité de Firebase Analytics sans risquer de bloquer main()
  bool isAnalyticsSupported = false;
  try {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    isAnalyticsSupported = true;
    dev.log('Firebase Analytics initialisé avec succès', name: 'MAIN');
  } catch (e) {
    dev.log(
      'Firebase Analytics non supporté sur ce binaire natif (support rétro-compatible Shorebird): $e',
      name: 'MAIN',
    );
  }

  // 5. Initialiser les dépendances (GetIt)
  try {
    await initInjector(isAnalyticsSupported: isAnalyticsSupported);
  } catch (e, stackTrace) {
    dev.log(
      'initInjector error: $e',
      name: 'MAIN',
      error: e,
      stackTrace: stackTrace,
    );
  }

  // 6. Initialiser le service de notifications
  try {
    await sl<NotificationService>().initialize();
  } catch (e, stackTrace) {
    dev.log(
      'NotificationService initialization error: $e',
      name: 'MAIN',
      error: e,
      stackTrace: stackTrace,
    );
  }

  // 7. Lancement garanti de l'application UI
  runApp(const MyFFSCApp());
}
