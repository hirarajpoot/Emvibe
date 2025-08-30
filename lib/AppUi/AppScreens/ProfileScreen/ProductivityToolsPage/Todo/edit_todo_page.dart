import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../Controllers/todo_controller.dart';
import '../../../../Models/todo_model.dart';

class EditTodoPage extends StatelessWidget {
  final Todo todo;

  const EditTodoPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.find();
    final TextEditingController textEditingController = TextEditingController(text: todo.title);
    final RxBool isCompleted = todo.isCompleted.obs;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit To-Do".tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "To-Do Title".tr,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: "e.g., Buy groceries".tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
            SizedBox(height: 16.h),
            Obx(
              () => Row(
                children: [
                  Checkbox(
                    value: isCompleted.value,
                    onChanged: (bool? value) {
                      isCompleted.value = value ?? false;
                    },
                  ),
                  Text(
                    "Completed".tr,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Update title
                  todoController.updateTodoTitle(todo.id, textEditingController.text);
                  
                  // Update status if changed
                  if (isCompleted.value != todo.isCompleted) {
                    todoController.updateTodoStatus(todo.id, isCompleted.value);
                  }
                  
                  Get.back(); // Navigate back to the update page
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  "Update To-Do".tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}