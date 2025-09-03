// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: androidInitializationSettings,
//     );

//     await _notificationsPlugin.initialize(initializationSettings);
//   }

//   static Future<void> showNotification({
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'booking_channel', // channel ID
//       'Booking Notifications', // channel name
//       channelDescription: 'This channel is for booking confirmations',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//     );

//     await _notificationsPlugin.show(
//       0, // notification ID
//       title,
//       body,
//       details,
//     );
//   }
// }
