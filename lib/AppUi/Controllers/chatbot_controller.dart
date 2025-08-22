import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
// import 'package:collection/collection.dart';
import 'package:share_plus/share_plus.dart'; // 🔥 YEH LINE ZAROOR HONI CHAHIYE 🔥

import '../Models/message_model.dart';
import '../Models/chat_session_model.dart'; 

class ChatBotController extends GetxController {
  final TextEditingController textController = TextEditingController();

  final RxList<Message> messages = <Message>[
    Message.textMsg("Hello! How can I help you today?", isUser: false),
  ].obs;

  final RxList<ChatSession> chatHistory = <ChatSession>[].obs;
  final RxInt currentChatSessionIndex = RxInt(-1); 

  final RxString currentPersona = 'Friendly'.obs;

  final isAttachmentOpen = false.obs;
  final isListening = false.obs;
  final isRecording = false.obs;
  final isRecordingUIActive = false.obs;
  final recordDurationMs = 0.obs;
  final hasText = false.obs;

  late stt.SpeechToText _speech;
  DateTime? _recordStart;
  String? _tempRecordingPath;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
    textController.addListener(() {
      hasText.value = textController.text.trim().isNotEmpty;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    try {
      _speech.stop();
    } catch (_) {}
    _timer?.cancel();
    super.onClose();
  }

  void toggleAttachment() => isAttachmentOpen.toggle();

  void sendMessage([String? msg]) {
    final text = (msg ?? textController.text).trim();
    if (text.isEmpty) return;

    messages.add(Message.textMsg(text, isUser: true));
    textController.clear();

    Future.delayed(const Duration(milliseconds: 500), () {
      messages.add(Message.textMsg("Bot reply to: $text", isUser: false));
    });
  }

  // ---------- CHAT HISTORY SYSTEM ----------

  void saveCurrentChatToHistory() {
    if (messages.length > 1) { 
      final currentChatMessages = List<Message>.from(messages); 

      if (currentChatSessionIndex.value != -1 && currentChatSessionIndex.value < chatHistory.length) {
        chatHistory[currentChatSessionIndex.value].updateMessages(currentChatMessages);
      } else {
        final newSession = ChatSession(
          messages: currentChatMessages,
        );
        chatHistory.add(newSession);
        currentChatSessionIndex.value = chatHistory.length - 1;
      }
    }
  }

  void loadChatFromHistory(int index) {
    if (index >= 0 && index < chatHistory.length) {
      saveCurrentChatToHistory();
      messages.assignAll(chatHistory[index].messages);
      currentChatSessionIndex.value = index;
      textController.clear();
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
    
    if (currentChatSessionIndex.value != -1 && 
        currentChatSessionIndex.value < chatHistory.length &&
        !chatHistory[currentChatSessionIndex.value].isPinned.value) {
      messages.clear();
      messages.add(Message.textMsg("Hello! How can I help you today?", isUser: false));
      currentChatSessionIndex.value = -1;
    } else if (currentChatSessionIndex.value != -1 && 
               currentChatSessionIndex.value < chatHistory.length &&
               chatHistory[currentChatSessionIndex.value].isPinned.value) {
      final currentActivePinnedSession = chatHistory[currentChatSessionIndex.value];
      final newIndex = pinnedChats.indexOf(currentActivePinnedSession);
      currentChatSessionIndex.value = newIndex;
    } else { 
      messages.clear();
      messages.add(Message.textMsg("Hello! How can I help you today?", isUser: false));
      currentChatSessionIndex.value = -1;
    }

    chatHistory.assignAll(pinnedChats); 
  }

  void deleteChatSession(ChatSession sessionToDelete) {
    final int index = chatHistory.indexOf(sessionToDelete); 
    if (index != -1) {
      if (currentChatSessionIndex.value == index) {
        messages.clear();
        messages.add(Message.textMsg("Hello! How can I help you today?", isUser: false));
        currentChatSessionIndex.value = -1; 
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

  // 🔥 YEH FUNCTION AB DOBARA YAHAN HAI 🔥
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
    await Share.share(chatContent.toString()); // Native share dialog open karega
  }


  void startNewChat() {
    saveCurrentChatToHistory();

    messages.clear(); 
    textController.clear(); 
    messages.add(
      Message.textMsg("Hello! How can I help you today?", isUser: false),
    );
    currentChatSessionIndex.value = -1; 

    if (isListening.value) {
      stopListening();
    }
    if (isRecording.value) {
      stopVoiceRecord(send: false);
    }
  }

  // 🔥 Function to update the selected persona
  void updatePersona(String newPersona) {
    currentPersona.value = newPersona;
    log("Persona changed to: ${currentPersona.value}");
  }

  // ---------- Speech-to-Text (No changes) ----------
  Future<void> startListening() async {
    if (isListening.value) return;

    final mic = await Permission.microphone.request();
    if (mic.isDenied || mic.isPermanentlyDenied) {
      log("Microphone permission denied.");
      return;
    }

    try {
      final available = await _speech.initialize(
        onStatus: (val) {
          log("STT STATUS: $val");
          final v = val.toLowerCase();
          if (v.contains("notlistening") || v.contains("done")) {
            isListening.value = false;
          }
        },
        onError: (err) {
          log("STT ERROR: $err");
          isListening.value = false;
        },
      );

      if (!available) {
        log("Speech recognizer not available.");
        return;
      }

      textController.text = "";
      isListening.value = true;

      _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            textController.text = result.recognizedWords;
            textController.selection = TextSelection.fromPosition(
              TextPosition(offset: textController.text.length),
            );
          }
        },
        listenMode: stt.ListenMode.dictation,
      );
    } catch (e) {
      log("STT init error: $e");
      log("Speech recognition failed to start: $e");
      isListening.value = false;
    }
  }

  Future<void> stopListening() async {
    if (!isListening.value) return;
    try {
      await _speech.stop();
    } catch (_) {}
    isListening.value = false;
  }

  // ---------- Voice Note (No changes) ----------
  Future<void> startVoiceRecord() async {
    if (isRecording.value) return;

    if (isListening.value) {
      await stopListening();
    }

    final mic = await Permission.microphone.request();
    if (mic.isDenied || mic.isPermanentlyDenied) {
      log("Microphone permission denied for voice record.");
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final filePath =
          "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a";

      final f = File(filePath);
      if (!f.existsSync()) {
        f.createSync(recursive: true);
      }

      _tempRecordingPath = filePath;
      _recordStart = DateTime.now();
      recordDurationMs.value = 0;
      isRecording.value = true;
      isRecordingUIActive.value = true;

      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_recordStart != null) {
          recordDurationMs.value = DateTime.now()
              .difference(_recordStart!)
              .inMilliseconds;
        }
      });
    } catch (e) {
      log("startVoiceRecord error: $e");
      log("Unable to start recording (simulated): $e");
    }
  }

  Future<void> stopVoiceRecord({bool send = true}) async {
    if (!isRecording.value) return;

    _timer?.cancel();
    isRecording.value = false;
    isRecordingUIActive.value = false;

    try {
      final durMs = _recordStart == null
          ? 0
          : DateTime.now().difference(_recordStart!).inMilliseconds;

      final path = _tempRecordingPath;
      _tempRecordingPath = null;
      _recordStart = null;
      recordDurationMs.value = 0;

      if (send && path != null && File(path).existsSync() && durMs > 300) {
        messages.add(
          Message.voiceMsg(path: path, durationMs: durMs, isUser: true),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          messages.add(
            Message.textMsg("Got your voice note 🎧", isUser: false),
          );
        });
      } else {
        if (path != null && File(path).existsSync()) {
          try {
            await File(path).delete();
          } catch (_) {}
        }
      }
    } catch (e) {
      log("stopVoiceRecord error: $e");
      log("Recording failed: $e");
      isRecording.value = false;
      isRecordingUIActive.value = false;
      _recordStart = null;
      recordDurationMs.value = 0;
      _tempRecordingPath = null;
    }
  }

  void cancelVoiceRecord() {
    stopVoiceRecord(send: false);
  }

  // Attachments (No changes)
  Future<void> pickFromCamera() async {
    final cameraPerm = await Permission.camera.request();
    if (cameraPerm.isDenied || cameraPerm.isPermanentlyDenied) {
      log("Camera permission denied.");
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      sendMessage("📷 Image: ${picked.path}");
    }
    isAttachmentOpen.value = false;
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      sendMessage("📄 File: ${result.files.single.name}");
    }
    isAttachmentOpen.value = false;
  }

  void _snack(String msg) {
  }
}
