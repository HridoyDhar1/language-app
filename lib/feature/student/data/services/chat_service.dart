import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID with null safety
  String getCurrentUserId() {
    return _auth.currentUser?.uid ?? '';
  }

  // Send a message with error handling
  Future<void> sendMessage(String receiverId, String message, String bookingId) async {
    try {
      final String currentUserId = getCurrentUserId();
      if (currentUserId.isEmpty) {
        throw Exception('User not authenticated');
      }

      final String currentUserEmail = _auth.currentUser?.email ?? 'Unknown User';
      final Timestamp timestamp = Timestamp.now();

      // Create a new message
      Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
        bookingId: bookingId,
      );

      // Create chat room ID (unique for booking + participants)
      List<String> ids = [currentUserId, receiverId, bookingId];
      ids.sort();
      String chatRoomId = ids.join('_');

      // Add message to the chat room
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // Get messages with error handling
  Stream<QuerySnapshot> getMessages(String userId, String receiverId, String bookingId) {
    try {
      List<String> ids = [userId, receiverId, bookingId];
      ids.sort();
      String chatRoomId = ids.join('_');

      return _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
    } catch (e) {
      print('Error getting messages: $e');
      rethrow;
    }
  }
}

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String bookingId;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.bookingId,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'bookingId': bookingId,
    };
  }
}