import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'dart:async';
import 'package:uuid/uuid.dart';

import '../../Models/reminder_model.dart';

class ReminderController extends GetxController {
  final RxString title = ''.obs;
  final RxString description = ''.obs;
  final Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);
  
  final RxList<Reminder> reminders = <Reminder>[].obs;

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
      // Keep existing time if it exists, otherwise use current time
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
        "Please fill in all fields.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final newReminder = Reminder(
      id: const Uuid().v4(),
      title: title.value,
      description: description.value,
      reminderDateTime: selectedDateTime.value!,
    );

    reminders.add(newReminder);
    reminders.refresh();

    // Reset fields after creating a reminder
    title.value = '';
    description.value = '';
    selectedDateTime.value = null;

    Get.snackbar(
      "Success".tr,
      "Reminder created successfully!".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}