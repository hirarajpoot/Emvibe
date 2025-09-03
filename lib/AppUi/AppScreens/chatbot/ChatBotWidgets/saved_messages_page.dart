import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emvibe/AppUi/Controllers/chatbot_controller.dart';
import 'package:emvibe/AppUi/Controllers/GeneralSettingsController.dart';
// Make sure to import your message tile widget here
// import 'package:emvibe/AppUi/AppScreens/chatbot/widgets/message_tile.dart';

class SavedMessagesPage extends StatelessWidget {
  const SavedMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatBotController>();
    final settingsController = Get.find<GeneralSettingsController>();
    final isDarkMode = settingsController.isDarkMode.value;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Book", style: TextStyle(color: textColor)),
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0.5,
      ),
      body: Obx(() {
        if (chatController.savedMessages.isEmpty) {
          return Center(
            child: Text(
              "No saved messages yet. Long-press on a chat message to save it.",
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor.withOpacity(0.6)),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: chatController.savedMessages.length,
          itemBuilder: (context, index) {
            final message = chatController.savedMessages[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  message.text,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    chatController.deleteSavedMessage(message);
                  },
                ),
                // Here you would use your MessageTile or a custom widget to display the saved message.
                // For example:
                // child: MessageTile(message: message),
              ),
            );
          },
        );
      }),
    );
  }
}