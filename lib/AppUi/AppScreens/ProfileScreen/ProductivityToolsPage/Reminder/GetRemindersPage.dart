import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../Controllers/Reminder/reminder_controller.dart';

class GetRemindersPage extends StatelessWidget {
  const GetRemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReminderController reminderController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Reminders".tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Obx(
        () {
          // Check if the reminders list is empty
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
                    "No reminders yet.".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Create a new reminder to see it here.".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            );
          }
          // Display the list of reminders
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: reminderController.reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminderController.reminders[index];
              return Card(
                color: Theme.of(context).cardColor,
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
              );
            },
          );
        },
      ),
    );
  }
}