import 'package:get/get.dart';
import 'package:uuid/uuid.dart'; 
import 'package:collection/collection.dart'; 

import 'message_model.dart'; 

class ChatSession {
  final String id; 
  RxString customTitle;   
  RxList<Message> messages; 
  RxBool isPinned; 
  final bool isIncognito; // 🔥 Fix: 'isIncognito' field correctly defined here

  ChatSession({
    String? id, 
    required List<Message> messages, 
    String? initialTitle, 
    bool isPinned = false,
    this.isIncognito = false, // 🔥 Fix: 'isIncognito' as a named parameter with default value
  })  : id = id ?? const Uuid().v4(), 
        this.messages = messages.obs, 
        customTitle = (initialTitle ?? _deriveTitleFromMessages(messages)).obs,
        this.isPinned = isPinned.obs;

  static String _deriveTitleFromMessages(List<Message> msgs) {
    final firstUserMessage = msgs.firstWhereOrNull((msg) => msg.isUser && msg.text.isNotEmpty);
    if (firstUserMessage != null && firstUserMessage.text.isNotEmpty) {
      return firstUserMessage.text.substring(0, firstUserMessage.text.length.clamp(0, 25)) + (firstUserMessage.text.length > 25 ? '...' : '');
    }
    return "New Chat Session"; 
  }

  void updateTitle(String newTitle) {
    customTitle.value = newTitle;
  }

  void updateMessages(List<Message> newMessages) {
    messages.assignAll(newMessages); 
    if (customTitle.value.startsWith("New Chat Session") || customTitle.value.startsWith("Chat Session")) {
      customTitle.value = _deriveTitleFromMessages(newMessages);
    }
  }
}
