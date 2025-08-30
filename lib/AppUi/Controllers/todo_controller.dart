import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Models/todo_model.dart';

class TodoController extends GetxController {
  final RxString newTodoTitle = ''.obs;
  final RxList<Todo> todos = <Todo>[].obs;

  void setNewTodoTitle(String value) {
    newTodoTitle.value = value;
  }

  void addTodo() {
    if (newTodoTitle.isEmpty) {
      Get.snackbar(
        "Error".tr,
        "Todo title cannot be empty.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final newTodo = Todo.create(title: newTodoTitle.value);
    todos.add(newTodo);

    // Reset input field
    newTodoTitle.value = '';

    Get.snackbar(
      "Success".tr,
      "To-Do added successfully!".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void updateTodoStatus(String id, bool isCompleted) {
    final todoIndex = todos.indexWhere((todo) => todo.id == id);
    if (todoIndex != -1) {
      todos[todoIndex].isCompleted = isCompleted;
      todos.refresh();
      Get.snackbar(
        "Updated".tr,
        "To-Do status updated.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  // ✅ New method to update the to-do title
  void updateTodoTitle(String id, String newTitle) {
    if (newTitle.isEmpty) {
      Get.snackbar(
        "Error".tr,
        "Todo title cannot be empty.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    final todoIndex = todos.indexWhere((todo) => todo.id == id);
    if (todoIndex != -1) {
      todos[todoIndex].title = newTitle;
      todos.refresh();
      Get.snackbar(
        "Updated".tr,
        "To-Do title updated.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  // ✅ Updated Delete To-Do functionality with confirmation dialog
  void showDeleteConfirmation(String id) {
    Get.defaultDialog(
      title: "Delete To-Do".tr,
      middleText: "Are you sure you want to delete this to-do?".tr,
      textConfirm: "Delete".tr,
      textCancel: "Cancel".tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        deleteTodo(id);
        Get.back(); // Close the dialog
      },
    );
  }

  void deleteTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);
    todos.refresh();
    Get.snackbar(
      "Deleted".tr,
      "To-Do deleted successfully!".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}