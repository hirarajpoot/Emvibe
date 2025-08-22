import 'package:get/get.dart'; 
import 'message_model.dart'; 

class ChatSession {
  List<Message> messages; 
  RxString customTitle;   
  RxBool isPinned;      

  ChatSession({required this.messages, String? initialTitle, bool isPinned = false})
      : customTitle = (initialTitle ?? _deriveTitleFromMessages(messages)).obs,
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
    messages = newMessages;
    if (customTitle.value.startsWith("New Chat Session") || customTitle.value.startsWith("Chat Session")) {
      customTitle.value = _deriveTitleFromMessages(newMessages);
    }
  }
}
