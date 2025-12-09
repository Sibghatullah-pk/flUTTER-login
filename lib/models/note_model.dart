import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String color; // Hex color code for note card
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    this.content = '',
    this.color = '#FFFFFF',
    this.createdAt,
    this.updatedAt,
  });

  // Create from Firestore document
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      color: map['color'] ?? '#FFFFFF',
      createdAt: _parseTimestamp(map['createdAt']),
      updatedAt: _parseTimestamp(map['updatedAt']),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'color': color,
    };
  }

  // Helper to parse Firestore Timestamp
  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  // Create a copy with modified fields
  NoteModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title)';
  }
}
