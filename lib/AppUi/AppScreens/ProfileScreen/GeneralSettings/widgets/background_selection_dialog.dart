import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/GeneralSettingsController.dart';
import '../../../chatbot/chatbot_page.dart';

class BackgroundSelectionDialog extends StatelessWidget {
  const BackgroundSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<GeneralSettingsController>();
    return AlertDialog(
      backgroundColor: settingsController.isDarkMode.value ? Colors.grey.shade800 : Colors.white,
      title: Text(
        "set_background".tr,
        style: TextStyle(color: settingsController.isDarkMode.value ? Colors.white : Colors.black),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              "select_from_gallery".tr,
              style: TextStyle(color: settingsController.isDarkMode.value ? Colors.white : Colors.black),
            ),
            onTap: () async {
              Get.back(); // Close the dialog.
              await settingsController.setCustomBackground();
              // If an image was successfully selected, navigate back to the chat screen.
              if (settingsController.customBackgroundPath.value.isNotEmpty) {
                Get.offAll(() => ChatBotPage());
              }
            },
          ),
          if (settingsController.customBackgroundPath.isNotEmpty)
            ListTile(
              title: Text(
                "remove_background".tr,
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                settingsController.removeCustomBackground();
              },
            ),
        ],
      ),
    );
  }
}