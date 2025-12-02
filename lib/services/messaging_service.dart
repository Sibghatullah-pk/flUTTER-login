import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Initialize messaging
  Future<void> initialize() async {
    // Request permission
    await requestPermission();

    // Get FCM token
    String? token = await getToken();
    if (token != null) {
      debugPrint('FCM Token: $token');
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check if app was opened from a notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
  }

  // Request notification permission
  Future<NotificationSettings> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus}');
    return settings;
  }

  // Get FCM token
  Future<String?> getToken() async {
    try {
      if (kIsWeb) {
        // For web, you need to provide VAPID key
        // Get it from Firebase Console > Project Settings > Cloud Messaging > Web Push certificates
        return await _messaging.getToken();
      }
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    if (!kIsWeb) {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!kIsWeb) {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    }
  }

  // Handle foreground message
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message received:');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    // You can show a local notification or update UI here
    onMessageReceived?.call(message);
  }

  // Handle message when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('App opened from notification:');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Data: ${message.data}');

    onMessageOpenedApp?.call(message);
  }

  // Handle initial message (app was terminated)
  void _handleInitialMessage(RemoteMessage message) {
    debugPrint('App opened from terminated state:');
    debugPrint('Title: ${message.notification?.title}');

    onMessageOpenedApp?.call(message);
  }

  // Callbacks for handling messages
  Function(RemoteMessage)? onMessageReceived;
  Function(RemoteMessage)? onMessageOpenedApp;
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.notification?.title}');
}
