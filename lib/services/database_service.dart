import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Save user profile
  Future<void> saveUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _database.child('users').child(userId).set(data);
    } catch (e) {
      throw 'Failed to save user profile: $e';
    }
  }

  // Update user profile
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _database.child('users').child(userId).update(data);
    } catch (e) {
      throw 'Failed to update user profile: $e';
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final snapshot = await _database.child('users').child(userId).get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user profile: $e';
    }
  }

  // Stream user profile
  Stream<DatabaseEvent> streamUserProfile(String userId) {
    return _database.child('users').child(userId).onValue;
  }

  // Delete user profile
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _database.child('users').child(userId).remove();
    } catch (e) {
      throw 'Failed to delete user profile: $e';
    }
  }
}
