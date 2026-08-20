import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation strictly to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initInjector();

  try {
    await sl<NotificationService>().initialize();
  } catch (e, stackTrace) {
    dev.log(
      'Erreur lors de l’initialisation de NotificationService dans main()',
      name: 'MAIN',
      error: e,
      stackTrace: stackTrace,
    );
  }

  runApp(const MyFFSCApp());
}
