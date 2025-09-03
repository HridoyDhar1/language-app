import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory AppNotification.fromMap(String id, Map<String, dynamic> map) {
    return AppNotification(
      id: id,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
