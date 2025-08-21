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

import '../Models/message_model.dart';

class ChatBotController extends GetxController {
  final TextEditingController textController = TextEditingController();

  // Active chat messages
  final RxList<Message> messages = <Message>[
    Message.textMsg("Hello! How can I help you today?", isUser: false),
  ].obs;

  // Chat history (list of sessions)
  final RxList<List<Message>> chatHistory = <List<Message>>[].obs;
  // Current active chat session index. -1 means no specific session loaded.
  final RxInt currentChatSessionIndex = RxInt(-1); 

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

  // ---------- CHAT HISTORY SYSTEM (Improved Logic) ----------

  // Saves/Updates the current chat to history
  void saveCurrentChatToHistory() {
    if (messages.length > 1) { 
      final currentChatMessages = List<Message>.from(messages);
      if (currentChatSessionIndex.value != -1 && currentChatSessionIndex.value < chatHistory.length) {
        // Existing session ko update karein
        chatHistory[currentChatSessionIndex.value] = currentChatMessages;
      } else {
        // Naya session add karein
        chatHistory.add(currentChatMessages);
        currentChatSessionIndex.value = chatHistory.length - 1; 
      }
    }
  }

  // Loads a specific chat from history
  void loadChatFromHistory(int index) {
    if (index >= 0 && index < chatHistory.length) {
      saveCurrentChatToHistory(); // 🔥 IMPORTANT: Pehle current chat ko save karein
      messages.assignAll(chatHistory[index]); // Purani chat ko load karein
      currentChatSessionIndex.value = index; // Update current session index
      textController.clear(); // Input field clear karein
    } else {
      log("Error: Invalid chat session index $index for loading.");
    }
  }

  // Provides access to chat history for UI
  RxList<List<Message>> getAllChatSessions() {
    return chatHistory;
  }

  // Clears all chat history
  void clearChatHistory() {
    chatHistory.clear(); // Saari saved sessions clear karein
    messages.clear(); // Current chat screen ko bhi clear karein
    textController.clear(); // Input field clear karein
    currentChatSessionIndex.value = -1; // Reset current session index
    messages.add(Message.textMsg("Hello! How can I help you today?", isUser: false)); // New greeting for current screen
  }

  // 🔥 NEW: Function to delete a specific chat session by index
  void deleteChatSession(int index) {
    if (index >= 0 && index < chatHistory.length) {
      // Agar current loaded session delete ho rahi hai
      if (currentChatSessionIndex.value == index) {
        // Current chat ko bhi clear kar do aur naya session shuru kar do
        messages.clear();
        messages.add(Message.textMsg("Hello! How can I help you today?", isUser: false));
        currentChatSessionIndex.value = -1; // No session loaded
      } else if (currentChatSessionIndex.value > index) {
        // Agar deleted session current session se pehle thi, toh index adjust karo
        currentChatSessionIndex.value--;
      }
      chatHistory.removeAt(index); // Session ko list se delete karein
      // Get.snackbar("Chat Deleted", "Chat session deleted successfully!", snackPosition: SnackPosition.BOTTOM);
      // Ensure UI updates if needed (Obx will handle for chatHistory list)
    } else {
      Get.snackbar("Error", "Invalid chat session to delete!", snackPosition: SnackPosition.BOTTOM);
      log("Error: Invalid chat session index $index for deletion.");
    }
  }

  // Starts a new chat session
  void startNewChat() {
    saveCurrentChatToHistory(); // Naya chat shuru karne se pehle current chat ko save karein

    messages.clear(); 
    textController.clear(); 
    messages.add(
      Message.textMsg("Hello! How can I help you today?", isUser: false),
    );
    currentChatSessionIndex.value = -1; // New chat means no specific historical session

    if (isListening.value) {
      stopListening();
    }
    if (isRecording.value) {
      stopVoiceRecord(send: false);
    }
  }

  // ---------- Speech-to-Text ----------
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

  // ---------- Voice Note ----------
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

  // Attachments
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

  // void _snack(String msg) {
  //   // This function is empty as per previous instruction to remove snackbars.
  // }
}
