import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Controllers/note_controller.dart';
import 'package:intl/intl.dart';

class DeleteNotesPage extends StatelessWidget {
  const DeleteNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteController noteController = Get.find();
    final RxList<String> selectedNotes = <String>[].obs;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delete Notes".tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          Obx(
            () => selectedNotes.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Confirm Deletion".tr,
                        middleText: "Are you sure you want to delete the selected note(s)?".tr,
                        textConfirm: "Delete".tr,
                        textCancel: "Cancel".tr,
                        confirmTextColor: Colors.white,
                        cancelTextColor: Theme.of(context).primaryColor,
                        buttonColor: Colors.redAccent,
                        onConfirm: () {
                          for (var id in selectedNotes) {
                            noteController.deleteNote(id);
                          }
                          selectedNotes.clear();
                          Get.back();
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
                    "No notes to delete.".tr,
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
            itemCount: noteController.notes.length,
            itemBuilder: (context, index) {
              final note = noteController.notes[index];
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
                      value: selectedNotes.contains(note.id),
                      onChanged: (bool? value) {
                        if (value == true) {
                          selectedNotes.add(note.id);
                        } else {
                          selectedNotes.remove(note.id);
                        }
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}