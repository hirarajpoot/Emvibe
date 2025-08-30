import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Models/note_model.dart';

class NoteController extends GetxController {
  final RxString title = ''.obs;
  final RxString content = ''.obs;

  final RxList<Note> notes = <Note>[].obs;

  void setTitle(String value) {
    title.value = value;
  }

  void setContent(String value) {
    content.value = value;
  }

  void createNote() {
    if (title.isEmpty) {
      Get.snackbar(
        "Error".tr,
        "Note title cannot be empty.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final newNote = Note.create(title: title.value, content: content.value);
    notes.add(newNote);

    // Reset fields after creating a note
    title.value = '';
    content.value = '';

    Get.snackbar(
      "Success".tr,
      "Note created successfully!".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // 🔥 Delete Note Functionality
  void deleteNote(String id) {
    notes.removeWhere((note) => note.id == id);
    notes.refresh(); // UI ko refresh karne ke liye
  }
}