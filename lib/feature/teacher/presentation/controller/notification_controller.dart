import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationController extends GetxController {
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _listenForNotifications();
  }

  void _listenForNotifications() {
    FirebaseFirestore.instance
        .collection('notifications')
        .snapshots()
        .listen((snapshot) {
      // Example: count all notifications (or filter unread if you add a "read" field)
      unreadCount.value = snapshot.docs.length;
    });
  }

  void clearNotifications() {
    unreadCount.value = 0;
  }
}
