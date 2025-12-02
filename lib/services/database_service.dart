import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user profile
  Future<void> saveUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).set(data);
    } catch (e) {
      throw 'Failed to save user profile: $e';
    }
  }

  // Update user profile
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw 'Failed to update user profile: $e';
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw 'Failed to get user profile: $e';
    }
  }

  // Stream user profile
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserProfile(
      String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  // Delete user profile
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw 'Failed to delete user profile: $e';
    }
  }
}
