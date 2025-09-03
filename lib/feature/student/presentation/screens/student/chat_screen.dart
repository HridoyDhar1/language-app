import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:languageapp/feature/student/data/services/chat_service.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String bookingId;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.bookingId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await _chatService.sendMessage(
          widget.receiverId,
          _messageController.text,
          widget.bookingId,
        );
        _messageController.clear();
        
        // Scroll to bottom after sending a message
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    String senderId = _chatService.getCurrentUserId();
    
    return StreamBuilder(
      stream: _chatService.getMessages(senderId, widget.receiverId, widget.bookingId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading messages: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages yet. Start the conversation!'),
          );
        }

        // Scroll to bottom when messages load
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    try {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      
      // Check if current user is the sender
      bool isMe = data['senderId'] == _chatService.getCurrentUserId();
      
      // Align messages to right if sent by me, left otherwise
      Alignment alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
      Color bubbleColor = isMe ? Colors.deepPurple : Colors.grey[300]!;
      Color textColor = isMe ? Colors.white : Colors.black;

      return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Sender email for received messages
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    data['senderEmail'] ?? 'Unknown User',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              
              // Message bubble
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data['message'] ?? '',
                  style: TextStyle(color: textColor),
                ),
              ),
              
              // Timestamp
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _formatTimestamp(data['timestamp']),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: const Text('Error displaying message',
            style: TextStyle(color: Colors.red)),
      );
    }
  }

  // Format timestamp
  String _formatTimestamp(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate();
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }

  // Build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          
          // Send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.send, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }
}