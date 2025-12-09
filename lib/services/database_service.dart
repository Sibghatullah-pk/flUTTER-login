import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USER PROFILE CRUD ====================

  // CREATE - Save user profile
  Future<void> saveUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(userId).set(data);
    } catch (e) {
      throw 'Failed to save user profile: $e';
    }
  }

  // READ - Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      throw 'Failed to get user profile: $e';
    }
  }

  // UPDATE - Update user profile
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw 'Failed to update user profile: $e';
    }
  }

  // DELETE - Delete user profile
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw 'Failed to delete user profile: $e';
    }
  }

  // Stream user profile (Real-time updates)
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserProfile(
      String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  // ==================== TASKS CRUD ====================

  // CREATE - Add new task
  Future<String> createTask(
      String userId, Map<String, dynamic> taskData) async {
    try {
      taskData['userId'] = userId;
      taskData['createdAt'] = FieldValue.serverTimestamp();
      taskData['updatedAt'] = FieldValue.serverTimestamp();
      taskData['isCompleted'] = taskData['isCompleted'] ?? false;

      final docRef = await _firestore.collection('tasks').add(taskData);
      return docRef.id;
    } catch (e) {
      throw 'Failed to create task: $e';
    }
  }

  // READ - Get single task
  Future<Map<String, dynamic>?> getTask(String taskId) async {
    try {
      final doc = await _firestore.collection('tasks').doc(taskId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      throw 'Failed to get task: $e';
    }
  }

  // READ - Get all tasks for user
  Future<List<Map<String, dynamic>>> getUserTasks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      throw 'Failed to get user tasks: $e';
    }
  }

  // READ - Stream tasks (Real-time)
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // UPDATE - Update task
  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('tasks').doc(taskId).update(data);
    } catch (e) {
      throw 'Failed to update task: $e';
    }
  }

  // UPDATE - Toggle task completion
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'isCompleted': isCompleted,
        'completedAt': isCompleted ? FieldValue.serverTimestamp() : null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to toggle task: $e';
    }
  }

  // DELETE - Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw 'Failed to delete task: $e';
    }
  }

  // DELETE - Delete all user tasks
  Future<void> deleteAllUserTasks(String userId) async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw 'Failed to delete all tasks: $e';
    }
  }

  // ==================== NOTES CRUD ====================

  // CREATE - Add new note
  Future<String> createNote(
      String userId, Map<String, dynamic> noteData) async {
    try {
      noteData['userId'] = userId;
      noteData['createdAt'] = FieldValue.serverTimestamp();
      noteData['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore.collection('notes').add(noteData);
      return docRef.id;
    } catch (e) {
      throw 'Failed to create note: $e';
    }
  }

  // READ - Get all notes for user
  Future<List<Map<String, dynamic>>> getUserNotes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      throw 'Failed to get user notes: $e';
    }
  }

  // READ - Stream notes (Real-time)
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserNotes(String userId) {
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  // UPDATE - Update note
  Future<void> updateNote(String noteId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('notes').doc(noteId).update(data);
    } catch (e) {
      throw 'Failed to update note: $e';
    }
  }

  // DELETE - Delete note
  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore.collection('notes').doc(noteId).delete();
    } catch (e) {
      throw 'Failed to delete note: $e';
    }
  }

  // ==================== UTILITY METHODS ====================

  // Get document count for a collection
  Future<int> getCollectionCount(String collection, String userId) async {
    try {
      final snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Batch write multiple documents
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    try {
      final batch = _firestore.batch();

      for (var op in operations) {
        final String type = op['type'];
        final String collection = op['collection'];
        final Map<String, dynamic>? data = op['data'];
        final String? docId = op['docId'];

        final ref = docId != null
            ? _firestore.collection(collection).doc(docId)
            : _firestore.collection(collection).doc();

        switch (type) {
          case 'create':
            batch.set(ref, data!);
            break;
          case 'update':
            batch.update(ref, data!);
            break;
          case 'delete':
            batch.delete(ref);
            break;
        }
      }

      await batch.commit();
    } catch (e) {
      throw 'Batch write failed: $e';
    }
  }
}
