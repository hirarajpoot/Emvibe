import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart'; // Import for Flutter Timezone

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    // No need to call _initializeNotifications here, as init() method will handle it.
  }

  // Initialization method for the service, including timezone setup
  Future<void> init() async {
    await _configureLocalTimeZone(); // Configure timezone before initializing notifications
    await _initializeNotifications(); // Initialize notifications
  }

  // Configure local timezone for accurate scheduling
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
    if (timeZoneName != null) {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    }
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Optional: Handle what happens when a user taps the notification
        // For example, you can navigate them to the ChatBotPage or GetRemindersPage
        // based on the payload.
        // if (response.payload == 'chatbot_response') {
        //   Get.to(() => const ChatBotPage());
        // } else if (response.payload == 'reminder_payload') {
        //   Get.to(() => const GetRemindersPage());
        // }
      },
    );
  }

  // 🔥 IMPORTANT: Your original showChatbotNotification method is back!
  Future<void> showChatbotNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'chatbot_channel', // Channel ID for chatbot notifications
      'Chatbot Notifications', // Channel name
      channelDescription: 'Notifications from the chatbot for responses and updates',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID for chatbot (you might want to make this dynamic if multiple chatbot notifications are needed)
      title,
      body,
      platformChannelSpecifics,
      payload: 'chatbot_response',
    );
  }

  // NEW: Method to schedule a notification for a specific date and time (for Reminders)
  Future<void> scheduleNotification({
    required int id, // Unique ID for the reminder notification
    required String title,
    required String body,
    required DateTime scheduledDateTime, // The exact date and time for the reminder
  }) async {
    // Android-specific notification details for reminders
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminder_channel', // Unique Channel ID for reminders
      'Reminder Notifications', // Channel name visible in settings
      channelDescription: 'Notifications for user-set reminders', // Channel description
      importance: Importance.max, // High importance for reminders
      priority: Priority.high, // High priority
      ticker: 'Reminder', // Text shown in the status bar for a brief moment
    );

    // iOS-specific notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    // Convert DateTime to TZDateTime for timezone-aware scheduling
    final tz.TZDateTime tzScheduledDateTime =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id, // Notification ID
      title, // Notification title
      body, // Notification body/description
      tzScheduledDateTime, // The scheduled time
      platformChannelSpecifics, // Platform-specific details
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Allows notification even in Doze mode
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime, // Interpret as absolute time
      matchDateTimeComponents: DateTimeComponents.dateAndTime, // Match both date and time
      payload: 'reminder_payload', // Optional payload data to differentiate from chatbot notifications
    );
  }
}
