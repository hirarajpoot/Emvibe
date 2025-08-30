import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../Controllers/note_controller.dart';

class GetNotesPage extends StatelessWidget {
  const GetNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteController noteController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Notes".tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Obx(
        () {
          if (noteController.notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notes,
                    size: 80.w,
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "No notes yet.".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Create a new note to see it here.".tr,
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
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: noteController.notes.length,
            itemBuilder: (context, index) {
              final note = noteController.notes[index];
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
                    note.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  subtitle: Text(
                    note.content.length > 50 
                        ? note.content.substring(0, 50) + "..." 
                        : note.content,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                  ),
                  trailing: Text(
                    DateFormat.yMMMd().format(note.createdDate),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
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