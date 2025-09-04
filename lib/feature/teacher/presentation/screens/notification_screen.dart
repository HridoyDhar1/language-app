import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageapp/feature/teacher/data/models/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
static const String name='notificaton_screen';
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications yet."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final notification = AppNotification.fromMap(
                docs[index].id,
                docs[index].data() as Map<String, dynamic>,
              );

              return ListTile(
                leading: const Icon(Icons.notifications, color: Colors.indigo),
                title: Text(notification.title),
                subtitle: Text(notification.message),
                trailing: Text(
                  "${notification.timestamp.hour}:${notification.timestamp.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
