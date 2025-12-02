import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // Log login event
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  // Log sign up event
  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  // Log screen view
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // Set user ID
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  // Clear user ID on logout
  Future<void> clearUserId() async {
    await _analytics.setUserId(id: null);
  }

  // Set user property
  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // Log custom event
  Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  // Log button click
  Future<void> logButtonClick(String buttonName) async {
    await _analytics.logEvent(
      name: 'button_click',
      parameters: {'button_name': buttonName},
    );
  }

  // Log profile update
  Future<void> logProfileUpdate() async {
    await _analytics.logEvent(name: 'profile_updated');
  }

  // Log app open
  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }
}
