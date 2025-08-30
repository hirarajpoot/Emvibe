import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../Models/reminder_model.dart'; // Assuming this path is correct
import '../../AppScreens/ProfileScreen/GeneralSettings/widgets/notification_service.dart'; // Import the NotificationService

class ReminderController extends GetxController {
  final RxString title = ''.obs;
  final RxString description = ''.obs;
  final Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);

  final RxList<Reminder> reminders = <Reminder>[].obs;

  // 🔥 NEW: Get an instance of NotificationService
  final NotificationService _notificationService = Get.find<NotificationService>();

  void setTitle(String value) {
    title.value = value;
  }

  void setDescription(String value) {
    description.value = value;
  }

  void selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay initialTime = selectedDateTime.value != null
          ? TimeOfDay.fromDateTime(selectedDateTime.value!)
          : TimeOfDay.now();

      selectedDateTime.value = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        initialTime.hour,
        initialTime.minute,
      );
    }
  }

  void selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedDateTime.value != null
          ? TimeOfDay.fromDateTime(selectedDateTime.value!)
          : TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final DateTime initialDate = selectedDateTime.value ?? DateTime.now();

      selectedDateTime.value = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }

  void createReminder() {
    if (title.isEmpty || selectedDateTime.value == null) {
      Get.snackbar(
        "Error".tr,
        "Please fill in all fields (title and date/time).".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final newReminder = Reminder(
      id: const Uuid().v4(),
      title: title.value,
      description: description.value.isEmpty ? "No description provided." : description.value, // Default description if empty
      reminderDateTime: selectedDateTime.value!,
    );

    reminders.add(newReminder);
    // reminders.refresh(); // No need for explicit refresh for RxList add/remove

    // 🔥 NEW: Schedule the local notification
    _notificationService.scheduleNotification(
      id: newReminder.id.hashCode, // Use a unique ID for the notification
      title: newReminder.title,
      body: newReminder.description,
      scheduledDateTime: newReminder.reminderDateTime,
    );

    // Reset fields after creating a reminder
    title.value = '';
    description.value = '';
    selectedDateTime.value = null;

    Get.snackbar(
      "Success".tr,
      "Reminder created and scheduled!".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void deleteReminder(String id) {
    reminders.removeWhere((reminder) => reminder.id == id);
    reminders.refresh(); // Explicit refresh might be useful here if other parts depend on it immediately
    // 🔥 NEW: Cancel the corresponding notification
    _notificationService.flutterLocalNotificationsPlugin.cancel(id.hashCode);
  }
}
