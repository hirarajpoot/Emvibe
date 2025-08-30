import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../Controllers/Reminder/reminder_controller.dart';

class DeleteReminderPage extends StatelessWidget {
  const DeleteReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReminderController reminderController = Get.find();
    // RxList to track selected reminders for deletion
    final RxList<String> selectedReminders = <String>[].obs;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delete Reminders".tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          Obx(
            () => selectedReminders.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Confirm Deletion".tr,
                        middleText:
                            "Are you sure you want to delete the selected reminder(s)?".tr,
                        textConfirm: "Delete".tr,
                        textCancel: "Cancel".tr,
                        confirmTextColor: Colors.white,
                        cancelTextColor: Theme.of(context).primaryColor,
                        buttonColor: Colors.redAccent,
                        onConfirm: () {
                          // Loop through selected reminders and delete them
                          for (var id in selectedReminders) {
                            reminderController.deleteReminder(id);
                          }
                          selectedReminders.clear();
                          Get.back(); // Close the dialog
                        },
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(
        () {
          if (reminderController.reminders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alarm_off,
                    size: 80.w,
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "No reminders to delete.".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: reminderController.reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminderController.reminders[index];
              return Obx(
                () => Card(
                  color: Theme.of(context).cardColor,
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    leading: Checkbox(
                      value: selectedReminders.contains(reminder.id),
                      onChanged: (bool? value) {
                        if (value == true) {
                          selectedReminders.add(reminder.id);
                        } else {
                          selectedReminders.remove(reminder.id);
                        }
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      reminder.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Text(
                          reminder.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14.w, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5)),
                            SizedBox(width: 5.w),
                            Text(
                              DateFormat.yMMMd().format(reminder.reminderDateTime),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Icon(Icons.access_time, size: 14.w, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5)),
                            SizedBox(width: 5.w),
                            Text(
                              DateFormat.jm().format(reminder.reminderDateTime),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}