import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:translator/translator.dart';

import '../Models/message_model.dart';
import '../Models/chat_session_model.dart';
import 'GeneralSettingsController.dart';
import '../AppScreens/ProfileScreen/GeneralSettings/widgets/notification_service.dart';

import 'services_chatbot_controller/speech_service.dart';
import 'services_chatbot_controller/voice_record_service.dart';
import 'services_chatbot_controller/attachment_service.dart';
import 'services_chatbot_controller/chat_history_manager.dart';

class ChatBotController extends GetxController with WidgetsBindingObserver {
  final TextEditingController textController = TextEditingController();

  final GeneralSettingsController settingsController = Get.find();
  final NotificationService notificationService = Get.find();

  final RxList<Message> messages = <Message>[].obs;
  final RxBool isBotTyping = false.obs;
  final RxString currentPersona = 'Friendly'.obs;
  final RxBool isAttachmentOpen = false.obs;
  final RxBool hasText = false.obs;

  final RxString userLanguage = 'en'.obs;
  GoogleTranslator translator = GoogleTranslator();

  final RxBool isAppInForeground = true.obs;

  late final SpeechService _speechService;
  late final VoiceRecordService _voiceRecordService;
  late final AttachmentService _attachmentService;
  late final ChatHistoryManager _chatHistoryManager;

  final RxBool isRecording = false.obs;
  final RxBool isRecordingUIActive = false.obs;
  final RxInt recordDurationMs = 0.obs;

  final RxBool speechEnabled = false.obs;
  final RxBool isListening = false.obs;
  final RxString recognizedText = ''.obs;

  final RxList<ChatSession> chatHistory = <ChatSession>[].obs;
  final RxInt currentChatSessionIndex = RxInt(-1);
  final RxBool isCurrentSessionIncognito = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    
    _voiceRecordService = VoiceRecordService(
      isRecording: isRecording,
      isRecordingUIActive: isRecordingUIActive,
      recordDurationMs: recordDurationMs,
      messages: messages,
      isBotTyping: isBotTyping,
      userLanguage: userLanguage,
      isAppInForeground: isAppInForeground, 
    );

    _speechService = SpeechService(
      isListening: isListening,
      speechEnabled: speechEnabled,
      recognizedText: recognizedText,
      textController: textController,
      onRecordStop: _voiceRecordService.stopVoiceRecord,
    );
    
    _attachmentService = AttachmentService(
      messages: messages,
      isAttachmentOpen: isAttachmentOpen,
      isBotTyping: isBotTyping,
      userLanguage: userLanguage,
      isAppInForeground: isAppInForeground, 
    );
    
    _chatHistoryManager = ChatHistoryManager(
      messages: messages,
      chatHistory: chatHistory,
      currentChatSessionIndex: currentChatSessionIndex,
      isCurrentSessionIncognito: isCurrentSessionIncognito,
    );
    
    textController.addListener(() {
      hasText.value = textController.text.trim().isNotEmpty;
    });

    _addInitialMessage();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    textController.dispose();
    _speechService.dispose();
    _voiceRecordService.dispose();
    super.onClose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isAppInForeground.value = true;
    } else if (state == AppLifecycleState.paused) {
      isAppInForeground.value = false;
    }
  }

  void _addInitialMessage() async {
    messages.add(Message.textMsg('initial_greeting'.tr, isUser: false));
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

  Future<void> startListening() async {
    if (isRecording.value) {
      _voiceRecordService.cancelVoiceRecord();
    }
    await _speechService.startListening();
  }
  
  Future<void> stopListening() => _speechService.stopListening();
  
  Future<void> startVoiceRecord() async {
    if (isListening.value) {
      await _speechService.stopListening();
    }
    _voiceRecordService.startVoiceRecord();
  }
  
  Future<void> stopVoiceRecord({bool send = true}) => _voiceRecordService.stopVoiceRecord(send: send);
  void cancelVoiceRecord() => _voiceRecordService.cancelVoiceRecord();

  Future<void> sendMessage() async {
    String textToSend = textController.text.trim();
    if (textToSend.isEmpty) return;
    
    if (isListening.value) {
      await stopListening();
    }
    if (isRecording.value) {
      cancelVoiceRecord();
    }

    final userMessage = Message.textMsg(textToSend, isUser: true);
    messages.add(userMessage);
    textController.clear();
    recognizedText.value = '';

    await _detectLanguage(textToSend);

    isBotTyping.value = true;
    await Future.delayed(const Duration(seconds: 2));
    String botResponse = "You said: '$textToSend'";
    String translatedBotResponse = await _translateText(botResponse, userLanguage.value);

    messages.add(Message.textMsg(translatedBotResponse, isUser: false));
    isBotTyping.value = false;

    if (!isAppInForeground.value && settingsController.notificationsEnabled.value) {
      notificationService.showChatbotNotification('Response Ready!', 'The chatbot has a new message for you.');
    }
  }

  Future<void> _detectLanguage(String text) async {
    try {
      final detection = await translator.translate(text);
      userLanguage.value = detection.sourceLanguage.code;
      Get.updateLocale(Locale(userLanguage.value));
    } catch (e) {
      log('Error detecting language: $e');
    }
  }

  Future<String> _translateText(String text, String targetLang) async {
    try {
      final translation = await translator.translate(text, to: targetLang);
      return translation.text;
    } catch (e) {
      log('Error translating text: $e');
      return text;
    }
  }

  void saveCurrentChatToHistory() => _chatHistoryManager.saveCurrentChatToHistory(messages.toList());
  void loadChatFromHistory(int index) => _chatHistoryManager.loadChatFromHistory(index);
  RxList<ChatSession> getSortedChatSessions() => _chatHistoryManager.getSortedChatSessions();
  void clearChatHistory() => _chatHistoryManager.clearChatHistory();
  void deleteChatSession(ChatSession sessionToDelete) => _chatHistoryManager.deleteChatSession(sessionToDelete);
  void renameChatSession(ChatSession sessionToRename, String newName) => _chatHistoryManager.renameChatSession(sessionToRename, newName);
  void togglePinStatus(ChatSession sessionToToggle) => _chatHistoryManager.togglePinStatus(sessionToToggle);
  Future<void> shareChatSession(ChatSession sessionToShare) => _chatHistoryManager.shareChatSession(sessionToShare);
  void startIncognitoChat() => _chatHistoryManager.startIncognitoChat();
  void startNewChat() => _chatHistoryManager.startNewChat();

  void updatePersona(String newPersona) {
    currentPersona.value = newPersona;
    log("Persona changed to: ${currentPersona.value}");
  }

  Future<void> pickFromCamera() async => await _attachmentService.pickFromCamera();
  Future<void> pickDocument() async => await _attachmentService.pickDocument();
}