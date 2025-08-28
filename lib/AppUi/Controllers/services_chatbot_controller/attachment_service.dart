import 'dart:developer';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:translator/translator.dart';
import 'dart:async';

import '../../Models/message_model.dart';
import '../GeneralSettingsController.dart';
import '../../AppScreens/ProfileScreen/GeneralSettings/widgets/notification_service.dart';

class AttachmentService {
  final RxList<Message> messages;
  final RxBool isAttachmentOpen;
  final RxBool isBotTyping;
  final RxString userLanguage;
  final NotificationService notificationService = Get.find();
  final GeneralSettingsController settingsController = Get.find();
  final RxBool isAppInForeground;
  final translator = GoogleTranslator();

  AttachmentService({
    required this.messages,
    required this.isAttachmentOpen,
    required this.isBotTyping,
    required this.userLanguage,
    required this.isAppInForeground,
  });

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
      isAttachmentOpen.value = false;
      
      isBotTyping.value = true;
      await Future.delayed(const Duration(seconds: 2));
      String ocrText = await FlutterTesseractOcr.extractText(picked.path, language: userLanguage.value);

      String botResponse;
      if (ocrText.isNotEmpty) {
        String translatedOcrText = await _translateText(
          "I read this from your image: '$ocrText'.",
          userLanguage.value,
        );
        botResponse = translatedOcrText;
      } else {
        String translatedResponse = await _translateText(
          "I couldn't read any text from that image.",
          userLanguage.value,
        );
        botResponse = translatedResponse;
      }

      messages.add(Message.textMsg(botResponse, isUser: false));
      isBotTyping.value = false;

      if (!isAppInForeground.value && settingsController.notificationsEnabled.value) {
        notificationService.showChatbotNotification('OCR Complete!', 'The chatbot has processed your image.');
      }
    }
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      messages.add(Message.fileMsg(path: result.files.single.path!, isUser: true, fileName: result.files.single.name));
      isAttachmentOpen.value = false;

      isBotTyping.value = true;
      await Future.delayed(const Duration(seconds: 2));
      String botResponse = await _translateText("Got your document!", userLanguage.value);

      messages.add(Message.textMsg(botResponse, isUser: false));
      isBotTyping.value = false;

      if (!isAppInForeground.value && settingsController.notificationsEnabled.value) {
        notificationService.showChatbotNotification('Document Processed!', 'The chatbot has received your document.');
      }
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
}