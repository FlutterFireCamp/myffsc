import 'dart:convert';
import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

/// Handler top-level pour traiter les messages FCM en arrière-plan et écran verrouillé.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  dev.log(
    'Message FCM d’arrière-plan reçu: ${message.messageId}, data: ${message.data}',
    name: 'NOTIFICATION_SERVICE',
  );
}

/// Service centralisé pour la gestion des notifications push Firebase (FCM)
/// et des notifications locales avec redirection interactive.
class NotificationService {
  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final FirebaseFirestore _firestore;

  static const String _channelId = 'ffsc_live_channel';
  static const String _channelName = 'Alertes Sessions Live & Examens FFSC';
  static const String _channelDescription =
      'Notifications pour les rappels de sessions directes Meet (1h, 30m, 15m, 5m, Live) et annonces.';

  NotificationService({
    FirebaseMessaging? fcm,
    FlutterLocalNotificationsPlugin? localNotifications,
    FirebaseFirestore? firestore,
  })  : _fcm = fcm ?? FirebaseMessaging.instance,
        _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Initialise les écouteurs FCM, les canaux de notifications locaux et les permissions.
  Future<void> initialize({
    Function(String route, Map<String, dynamic>? arguments)? onNavigate,
  }) async {
    try {
      dev.log('Initialisation du NotificationService...', name: 'NOTIFICATION_SERVICE');

      // 1. Enregistrement du background message handler FCM
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // 2. Demande des permissions utilisateur (iOS, Web & Android 13+)
      try {
        await _fcm.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );
      } catch (e) {
        dev.log('Avertissement FCM requestPermission: $e', name: 'NOTIFICATION_SERVICE');
      }

      // 3. Configuration des notifications locales pour le premier plan
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _handleNotificationPayload(response.payload, onNavigate: onNavigate);
        },
      );

      // 4. Création du canal Android haute importance et demande permission native Android 13+
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        try {
          await androidPlugin.requestNotificationsPermission();
        } catch (_) {}

        const androidChannel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );

        await androidPlugin.createNotificationChannel(androidChannel);
      }

      // 4. Écoute des messages en avant-plan (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        dev.log(
          'Message FCM reçu au premier plan: ${message.messageId}, data: ${message.data}',
          name: 'NOTIFICATION_SERVICE',
        );
        _showForegroundNotification(message);
      });

      // 5. Écoute du clic sur notification en arrière-plan
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        dev.log(
          'Notification cliquée depuis l’arrière-plan: ${message.data}',
          name: 'NOTIFICATION_SERVICE',
        );
        _handleMessageAction(message.data, onNavigate: onNavigate);
      });

      // 6. Vérification si l'application s'est ouverte via une notification (Terminated state)
      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        dev.log(
          'Application démarrée via une notification: ${initialMessage.data}',
          name: 'NOTIFICATION_SERVICE',
        );
        _handleMessageAction(initialMessage.data, onNavigate: onNavigate);
      }

      dev.log('NotificationService initialisé avec succès', name: 'NOTIFICATION_SERVICE');
    } catch (e, stackTrace) {
      dev.log(
        'Erreur critique lors de l’initialisation du NotificationService',
        name: 'NOTIFICATION_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Synchronise le token FCM de l'utilisateur dans son document Firestore.
  Future<void> syncUserFcmToken(String userId) async {
    try {
      String? token;
      try {
        token = await _fcm.getToken();
      } catch (e) {
        dev.log('Impossible de récupérer le token FCM pour l’instant: $e', name: 'NOTIFICATION_SERVICE');
      }

      if (token != null && token.isNotEmpty) {
        dev.log('Enregistrement du token FCM pour l’utilisateur $userId: $token', name: 'NOTIFICATION_SERVICE');
        await _firestore.collection('users').doc(userId).set({
          'fcmToken': token,
          'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      // Écouter les renouvellements de token
      _fcm.onTokenRefresh.listen((newToken) async {
        dev.log('Token FCM renouvelé pour $userId: $newToken', name: 'NOTIFICATION_SERVICE');
        try {
          await _firestore.collection('users').doc(userId).set({
            'fcmToken': newToken,
            'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } catch (e, stackTrace) {
          dev.log(
            'Erreur mise à jour du token FCM renouvelé',
            name: 'NOTIFICATION_SERVICE',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }, onError: (err) {
        dev.log('Erreur stream onTokenRefresh: $err', name: 'NOTIFICATION_SERVICE');
      });
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de la synchronisation du token FCM pour $userId',
        name: 'NOTIFICATION_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Affiche une notification locale interactive au premier plan.
  Future<void> _showForegroundNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final data = message.data;

      final title = notification?.title ?? data['title'] ?? 'Session Live FFSC';
      final body = notification?.body ?? data['body'] ?? 'Une nouvelle session commence.';

      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
      );

      final payload = jsonEncode(data);

      await _localNotifications.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de l’affichage de la notification locale',
        name: 'NOTIFICATION_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleNotificationPayload(
    String? payload, {
    Function(String route, Map<String, dynamic>? arguments)? onNavigate,
  }) {
    if (payload == null || payload.isEmpty) return;
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _handleMessageAction(data, onNavigate: onNavigate);
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors du décodage du payload de notification',
        name: 'NOTIFICATION_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Analyse les actions de la notification (ex: redirection vers lien Meet ou route interne).
  Future<void> _handleMessageAction(
    Map<String, dynamic> data, {
    Function(String route, Map<String, dynamic>? arguments)? onNavigate,
  }) async {
    try {
      final type = data['type'] as String? ?? '';
      final liveUrl = data['liveUrl'] as String? ?? data['meetUrl'] as String?;
      final targetRoute = data['route'] as String?;

      dev.log('Traitement de l’action de notification: type=$type, liveUrl=$liveUrl, route=$targetRoute', name: 'NOTIFICATION_SERVICE');

      // 1. Si c'est une notification de session Live directe avec URL Meet
      if (liveUrl != null && liveUrl.trim().isNotEmpty) {
        final uri = Uri.parse(
          liveUrl.startsWith('http') ? liveUrl : 'https://$liveUrl',
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: .externalApplication);
          return;
        }
      }

      // 2. Si une route interne est spécifiée (ex: '/tests', '/announcements', '/programs')
      if (targetRoute != null && targetRoute.isNotEmpty && onNavigate != null) {
        onNavigate(targetRoute, data);
        return;
      }

      // 3. Fallback selon le type
      if (onNavigate != null) {
        if (type == 'new_test') {
          onNavigate('/tests', data);
        } else if (type == 'urgent_announcement' || type == 'announcement') {
          onNavigate('/announcements', data);
        } else if (type.contains('live') || type == 'program') {
          onNavigate('/programs', data);
        }
      }
    } catch (e, stackTrace) {
      dev.log(
        'Erreur lors de l’exécution de l’action de notification',
        name: 'NOTIFICATION_SERVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
