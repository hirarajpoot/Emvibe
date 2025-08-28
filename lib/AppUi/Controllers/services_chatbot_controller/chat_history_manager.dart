import 'dart:developer';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../Models/message_model.dart';
import '../../Models/chat_session_model.dart';

class ChatHistoryManager {
  final RxList<Message> messages;
  final RxList<ChatSession> chatHistory;
  final RxInt currentChatSessionIndex;
  final RxBool isCurrentSessionIncognito;

  ChatHistoryManager({
    required this.messages,
    required this.chatHistory,
    required this.currentChatSessionIndex,
    required this.isCurrentSessionIncognito,
  });

  void saveCurrentChatToHistory(List<Message> currentMessages) {
    if (currentMessages.length > 1 && !isCurrentSessionIncognito.value) {
      if (currentChatSessionIndex.value != -1 && currentChatSessionIndex.value < chatHistory.length) {
        chatHistory[currentChatSessionIndex.value].updateMessages(currentMessages);
      } else {
        final newSession = ChatSession(
          messages: currentMessages,
          isIncognito: false,
        );
        chatHistory.add(newSession);
        currentChatSessionIndex.value = chatHistory.length - 1;
      }
    }
  }

  void loadChatFromHistory(int index) {
    if (index >= 0 && index < chatHistory.length) {
      saveCurrentChatToHistory(messages.toList());
      messages.assignAll(chatHistory[index].messages);
      currentChatSessionIndex.value = index;
      isCurrentSessionIncognito.value = false;
    } else {
      log("Error: Invalid chat session index $index for loading.");
    }
  }

  RxList<ChatSession> getSortedChatSessions() {
    final List<ChatSession> sortedList = List<ChatSession>.from(chatHistory);
    sortedList.sort((a, b) {
      if (a.isPinned.value && !b.isPinned.value) return -1;
      if (!a.isPinned.value && b.isPinned.value) return 1;
      return 0;
    });
    return sortedList.obs;
  }

  void clearChatHistory() {
    final List<ChatSession> pinnedChats = chatHistory.where((session) => session.isPinned.value).toList();

    if (isCurrentSessionIncognito.value) {
      messages.clear();
      messages.add(Message.textMsg('initial_greeting'.tr, isUser: false));
      currentChatSessionIndex.value = -1;
      isCurrentSessionIncognito.value = false;
    } else if (currentChatSessionIndex.value != -1 &&
        currentChatSessionIndex.value < chatHistory.length &&
        !chatHistory[currentChatSessionIndex.value].isPinned.value) {
      messages.clear();
      messages.add(Message.textMsg('initial_greeting'.tr, isUser: false));
      currentChatSessionIndex.value = -1;
    } else if (currentChatSessionIndex.value != -1 &&
        currentChatSessionIndex.value < chatHistory.length &&
        chatHistory[currentChatSessionIndex.value].isPinned.value) {
      messages.clear();
      messages.add(Message.textMsg('initial_greeting'.tr, isUser: false));
      final currentActivePinnedSession = pinnedChats.firstWhereOrNull((s) => s.id == chatHistory[currentChatSessionIndex.value].id);
      if(currentActivePinnedSession != null) {
        currentChatSessionIndex.value = pinnedChats.indexOf(currentActivePinnedSession);
      } else {
        currentChatSessionIndex.value = -1;
      }
    } else {
      messages.clear();
      messages.add(Message.textMsg('initial_greeting'.tr, isUser: false));
      currentChatSessionIndex.value = -1;
    }

    chatHistory.assignAll(pinnedChats);
    if (currentChatSessionIndex.value != -1 &&
        currentChatSessionIndex.value < chatHistory.length &&
        chatHistory[currentChatSessionIndex.value].isPinned.value) {
    } else if (pinnedChats.isNotEmpty) {
      loadChatFromHistory(0);
    } else {
      currentChatSessionIndex.value = -1;
    }
    isCurrentSessionIncognito.value = false;
  }

  void deleteChatSession(ChatSession sessionToDelete) {
    final int index = chatHistory.indexOf(sessionToDelete);
    if (index != -1) {
      if (currentChatSessionIndex.value != -1 &&
          currentChatSessionIndex.value < chatHistory.length &&
          chatHistory[currentChatSessionIndex.value].id == sessionToDelete.id) {
        startNewChat();
      } else if (currentChatSessionIndex.value > index) {
        currentChatSessionIndex.value--;
      }
      chatHistory.removeAt(index);
    } else {
      log("Error: Session not found for deletion.");
    }
  }

  void renameChatSession(ChatSession sessionToRename, String newName) {
    final int index = chatHistory.indexOf(sessionToRename);
    if (index != -1) {
      sessionToRename.updateTitle(newName);
    } else {
      log("Error: Session not found for renaming.");
    }
  }

  void togglePinStatus(ChatSession sessionToToggle) {
    final int index = chatHistory.indexOf(sessionToToggle);
    if (index != -1) {
      sessionToToggle.isPinned.toggle();
      chatHistory.refresh();
    } else {
      log("Error: Session not found for pinning/unpinning.");
    }
  }

  Future<void> shareChatSession(ChatSession sessionToShare) async {
    final StringBuffer chatContent = StringBuffer();
    chatContent.writeln("Chat Title: ${sessionToShare.customTitle.value}\n");

    for (final message in sessionToShare.messages) {
      if (message.isUser) {
        chatContent.writeln("You: ${message.text}");
      } else {
        chatContent.writeln("Bot: ${message.text}");
      }
    }
    await Share.share(chatContent.toString());
  }

  void startIncognitoChat() {
    saveCurrentChatToHistory(messages.toList());
    messages.clear();
    messages.add(Message.textMsg('incognito_welcome'.tr, isUser: false));
    currentChatSessionIndex.value = -1;
    isCurrentSessionIncognito.value = true;
    log("Incognito chat started.");
  }

  void startNewChat() {
    saveCurrentChatToHistory(messages.toList());
    messages.clear();
    messages.add(Message.textMsg('initial_greeting'.tr, isUser: false));
    currentChatSessionIndex.value = -1;
    isCurrentSessionIncognito.value = false;
    log("New regular chat started.");
  }
}