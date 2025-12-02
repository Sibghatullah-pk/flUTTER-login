import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/analytics_service.dart';
import 'services/messaging_service.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message: ${message.notification?.title}');
}

// Global services
final analyticsService = AnalyticsService();
final messagingService = MessagingService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with your project configuration
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAwdpTOHR2xiPMq44ORvFrpZ9WTHgUwhxc",
      authDomain: "flutter-login-5b689.firebaseapp.com",
      projectId: "flutter-login-5b689",
      storageBucket: "flutter-login-5b689.firebasestorage.app",
      messagingSenderId: "1063509425922",
      appId: "1:1063509425922:android:441695cf291d9d60738c1b",
    ),
  );

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize messaging service
  await messagingService.initialize();

  // Log app open
  await analyticsService.logAppOpen();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
      home: const LoginScreen(),
    );
  }
}
