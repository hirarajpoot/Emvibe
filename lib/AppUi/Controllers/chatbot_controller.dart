import 'dart:developer';
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart'; 
import 'package:record/record.dart'; 
import 'package:path_provider/path_provider.dart'; 
import 'dart:async'; 
import 'package:share_plus/share_plus.dart'; 
// import 'package:collection/collection.dart'; 

import '../Models/message_model.dart';
import '../Models/chat_session_model.dart'; 

class ChatBotController extends GetxController {
  final TextEditingController textController = TextEditingController();

  final RxList<Message> messages = <Message>[
    Message.textMsg("Hello! How can I help you today?", isUser: false),
  ].obs;

  final RxList<ChatSession> chatHistory = <ChatSession>[].obs;
  final RxInt currentChatSessionIndex = RxInt(-1); 
  final RxBool isCurrentSessionIncognito = false.obs; // 🔥 New: To track if current session is incognito

  final RxString currentPersona = 'Friendly'.obs;

  final RxBool isAttachmentOpen = false.obs;
  final RxBool hasText = false.obs; 

  // Speech-to-Text related variables
  late stt.SpeechToText _speechToText;
  final RxBool speechEnabled = false.obs; 
  final RxBool isListening = false.obs;   
  final RxString recognizedText = ''.obs; 

  // Voice Recording related variables
  late AudioRecorder _audioRecorder;
  final RxBool isRecording = false.obs; 
  final RxBool isRecordingUIActive = false.obs; 
  final RxInt recordDurationMs = 0.obs;
  DateTime? _recordStart;
  String? _tempRecordingPath;
  Timer? _timer;

  final RxBool isBotTyping = false.obs; 

  @override
  void onInit() {
    super.onInit();
    _speechToText = stt.SpeechToText();
    _initSpeechToText();

    _audioRecorder = AudioRecorder();
    
    textController.addListener(() {
      hasText.value = textController.text.trim().isNotEmpty;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    try {
      _speechToText.stop();
    } catch (_) {}
    try {
      _audioRecorder.dispose(); 
    } catch (_) {}
    _timer?.cancel(); 
    super.onClose();
  }

  void toggleAttachment() {
    isAttachmentOpen.toggle();
    if (!isAttachmentOpen.value) {
      FocusManager.instance.primaryFocus?.unfocus();
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusManager.instance.primaryFocus?.requestFocus();
      });
    }
  }

  // ---------- Speech-to-Text (For mic inside input field) ----------
  void _initSpeechToText() async {
    speechEnabled.value = await _speechToText.initialize(
      onStatus: (status) {
        log("STT STATUS: $status");
        if (status == 'listening') {
          isListening.value = true;
          recognizedText.value = ''; 
        } else if (status == 'notListening' || status == 'done' || status == 'onEndOfSpeech') {
          isListening.value = false;
          if (recognizedText.value.isNotEmpty) {
            textController.text = recognizedText.value;
            textController.selection = TextSelection.fromPosition(
              TextPosition(offset: textController.text.length),
            );
          }
        }
      },
      onError: (errorNotification) {
        isListening.value = false;
        log('Speech-to-Text Error: ${errorNotification.errorMsg}');
      },
    );
    if (!speechEnabled.value) {
      // No snackbar, silent fail if not enabled
    }
  }

  Future<void> startListening() async {
    if (isListening.value) {
      stopListening(); 
      return;
    }
    if (isRecording.value) {
      cancelVoiceRecord();
    }

    if (!speechEnabled.value) {
      log("Mic Error: Speech-to-text not initialized or permission denied.");
      return;
    }

    final micPermission = await Permission.microphone.request();
    if (micPermission.isDenied || micPermission.isPermanentlyDenied) {
      log("Microphone permission denied for speech-to-text.");
      return;
    }

    try {
      recognizedText.value = ''; 
      textController.text = ''; 
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenMode: stt.ListenMode.dictation,
      );
      isListening.value = true;
      log("STT listening started."); 
    } catch (e) {
      log("STT start error: $e");
      isListening.value = false;
    }
  }

  Future<void> stopListening() async {
    if (!isListening.value) return;
    try {
      await _speechToText.stop();
      log("STT listening stopped."); 
    } catch (_) {
    }
    isListening.value = false;
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    recognizedText.value = result.recognizedWords;
    textController.text = recognizedText.value; 
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );
  }

  // ---------- Voice Note (For a.png image icon, activated by long press) ----------
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
      if (await _audioRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final filePath = "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a";

        recordDurationMs.value = 0; 
        _recordStart = DateTime.now(); 
        log("Voice record start time set: $_recordStart"); 

        _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (_recordStart != null) {
            recordDurationMs.value = DateTime.now().difference(_recordStart!).inMilliseconds;
            recordDurationMs.refresh(); 
          }
        });

        await _audioRecorder.start(
          const RecordConfig(),
          path: filePath,
        );

        _tempRecordingPath = filePath;
        isRecording.value = true;
        isRecordingUIActive.value = true; 
        textController.clear(); 
        recognizedText.value = ''; 
        log("Voice record started. Path: $_tempRecordingPath"); 
      } else {
        log("Permission Denied: Microphone for voice recording.");
      }
    } catch (e) {
      log("startVoiceRecord error: $e");
      isRecording.value = false;
      isRecordingUIActive.value = false;
      _timer?.cancel(); 
      _recordStart = null;
      recordDurationMs.value = 0;
    }
  }

  Future<void> stopVoiceRecord({bool send = true}) async {
    if (!isRecording.value) return;

    _timer?.cancel(); 
    isRecording.value = false;
    isRecordingUIActive.value = false; 

    try {
      final path = await _audioRecorder.stop(); 
      
      final durMs = _recordStart == null
          ? 0
          : DateTime.now().difference(_recordStart!).inMilliseconds;

      _tempRecordingPath = null;
      _recordStart = null;
      recordDurationMs.value = 0; 
      log("Voice record stopped. Duration: $durMs ms, Path: $path"); 

      if (send && path != null && durMs > 300) { 
        messages.add(
          Message.voiceMsg(path: path, durationMs: durMs, isUser: true),
        );

        isBotTyping.value = true; 
        await Future.delayed(const Duration(seconds: 2));
        messages.add(
          Message.textMsg("Got your voice note 🎧", isUser: false),
        );
        isBotTyping.value = false; 
      } else {
        if (path != null && File(path).existsSync()) {
          try {
            await File(path).delete();
          } catch (_) {}
        }
      }
    } catch (e) {
      log("stopVoiceRecord error: $e");
      isRecording.value = false;
      isRecordingUIActive.value = false;
      _recordStart = null;
      recordDurationMs.value = 0;
      _tempRecordingPath = null;
    }
  }

  void cancelVoiceRecord() {
    log("Voice record cancelled."); 
    stopVoiceRecord(send: false);
  }

  // ---------- General Message Sending ----------
  Future<void> sendMessage() async {
    String textToSend = textController.text.trim();
    if (textToSend.isEmpty) return;

    if (isListening.value) {
      await stopListening();
    }
    if (isRecording.value) {
      cancelVoiceRecord();
    }
    
    messages.add(Message.textMsg(textToSend, isUser: true));
    textController.clear();
    recognizedText.value = ''; 
    
    isBotTyping.value = true;

    await Future.delayed(const Duration(seconds: 2));
    messages.add(
          Message.textMsg("You said: '$textToSend'", isUser: false),
        );
    isBotTyping.value = false;
  }

  // ---------- CHAT HISTORY SYSTEM ----------
  void saveCurrentChatToHistory() {
    // 🔥 Sirf non-incognito chats ko history mein save karein
    if (messages.length > 1 && !isCurrentSessionIncognito.value) { 
      final currentChatMessages = List<Message>.from(messages); 

      if (currentChatSessionIndex.value != -1 && currentChatSessionIndex.value < chatHistory.length) {
        chatHistory[currentChatSessionIndex.value].updateMessages(currentChatMessages);
      } else {
        final newSession = ChatSession(
          messages: currentChatMessages, 
          isIncognito: false, // Ensure non-incognito when saving to history
        );
        chatHistory.add(newSession);
        currentChatSessionIndex.value = chatHistory.length - 1;
      }
    }
  }

  void loadChatFromHistory(int index) {
    if (index >= 0 && index < chatHistory.length) {
      saveCurrentChatToHistory(); // Save current if it's not incognito
      messages.assignAll(chatHistory[index].messages);
      currentChatSessionIndex.value = index;
      isCurrentSessionIncognito.value = false; // 🔥 Not an incognito session
      textController.clear();
      if (isListening.value) stopListening(); 
      if (isRecording.value) cancelVoiceRecord(); 
      isRecordingUIActive.value = false; 
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
    
    // 🔥 Agar current session incognito hai, toh simply clear karein
    if (isCurrentSessionIncognito.value) {
      messages.clear();
      messages.add(Message.textMsg("Hello! How can I help you today?", isUser: false));
      currentChatSessionIndex.value = -1;
      isCurrentSessionIncognito.value = false;
    } else if (currentChatSessionIndex.value != -1 && 
               currentChatSessionIndex.value < chatHistory.length &&
               !chatHistory[currentChatSessionIndex.value].isPinned.value) {
      messages.clear();
      messages.add(Message.textMsg("Hello! How can I help you today?", isUser: false));
      currentChatSessionIndex.value = -1;
    } else if (currentChatSessionIndex.value != -1 && 
               currentChatSessionIndex.value < chatHistory.length &&
               chatHistory[currentChatSessionIndex.value].isPinned.value) {
      final currentActivePinnedSession = pinnedChats.firstWhereOrNull((s) => s.id == chatHistory[currentChatSessionIndex.value].id); 
      if(currentActivePinnedSession != null) {
        currentChatSessionIndex.value = pinnedChats.indexOf(currentActivePinnedSession);
      } else {
        currentChatSessionIndex.value = -1; 
      }
    } else { 
      messages.clear();
      messages.add(Message.textMsg("Hello! How can I help you today?", isUser: false));
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
    isCurrentSessionIncognito.value = false; // Ensure incognito flag is reset after clearing history

    if (isListening.value) stopListening(); 
    if (isRecording.value) cancelVoiceRecord(); 
    isRecordingUIActive.value = false; 
  }

  void deleteChatSession(ChatSession sessionToDelete) {
    final int index = chatHistory.indexOf(sessionToDelete); 
    if (index != -1) {
      // If current session is the one being deleted, reset to new chat
      if (currentChatSessionIndex.value != -1 &&
          currentChatSessionIndex.value < chatHistory.length &&
          chatHistory[currentChatSessionIndex.value].id == sessionToDelete.id) {
        startNewChat(); // Start a fresh new chat
      } else if (currentChatSessionIndex.value > index) {
        currentChatSessionIndex.value--;
      }
      chatHistory.removeAt(index); 
    } else {
      log("Error: Session not found for deletion.");
    }

    if (isListening.value) stopListening(); 
    if (isRecording.value) cancelVoiceRecord(); 
    isRecordingUIActive.value = false; 
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

  // 🔥 New Incognito Chat method
  void startIncognitoChat() {
    saveCurrentChatToHistory(); // Save current non-incognito chat if active

    messages.clear();
    textController.clear();
    messages.add(
      Message.textMsg("Welcome to Incognito Chat! This chat won't be saved.", isUser: false),
    );
    currentChatSessionIndex.value = -1; // No index in chat history
    isCurrentSessionIncognito.value = true; // 🔥 Mark as incognito

    if (isListening.value) {
      stopListening();
    }
    if (isRecording.value) { 
      cancelVoiceRecord();
    }
    isRecordingUIActive.value = false; 
    recognizedText.value = ''; 
    log("Incognito chat started.");
  }


  void startNewChat() {
    saveCurrentChatToHistory(); // Save current non-incognito chat if active

    messages.clear(); 
    textController.clear(); 
    messages.add(
      Message.textMsg("Hello! How can I help you today?", isUser: false),
    );
    currentChatSessionIndex.value = -1; 
    isCurrentSessionIncognito.value = false; // 🔥 Not an incognito session

    if (isListening.value) {
      stopListening();
    }
    if (isRecording.value) { 
      cancelVoiceRecord();
    }
    isRecordingUIActive.value = false; 
    recognizedText.value = ''; 
    log("New regular chat started.");
  }

  void updatePersona(String newPersona) {
    currentPersona.value = newPersona;
    log("Persona changed to: ${currentPersona.value}");
  }

  // ---------- Attachment Handling ----------
  Future<void> pickFromCamera() async {
    final cameraPerm = await Permission.camera.request();
    if (cameraPerm.isDenied || cameraPerm.isPermanentlyDenied) {
      log("Camera permission denied.");
      return;
    }
    final picker = ImagePicker(); 
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      messages.add(Message.imageMsg(path: picked.path, isUser: true));
      isBotTyping.value = true; 
      await Future.delayed(const Duration(seconds: 2));
      messages.add(Message.textMsg("Got your image!", isUser: false));
      isBotTyping.value = false; 
    }
    isAttachmentOpen.value = false;
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(); 
    if (result != null && result.files.isNotEmpty) {
      messages.add(Message.fileMsg(path: result.files.single.path!, isUser: true, fileName: result.files.single.name));
      isBotTyping.value = true; 
      await Future.delayed(const Duration(seconds: 2));
      messages.add(Message.textMsg("Got your document!", isUser: false));
      isBotTyping.value = false; 
    }
    isAttachmentOpen.value = false;
  }
}
