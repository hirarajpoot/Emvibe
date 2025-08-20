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
  // Text input
  final TextEditingController inputCtrl = TextEditingController();

  // Messages
  final RxList<Message> messages = <Message>[
    Message.textMsg("Hello! How can I help you today?", isUser: false),
  ].obs;

  // UI states
  final isAttachmentOpen = false.obs;
  final isListening = false.obs; // STT
  final isRecording = false.obs; // Voice note (simulated)
  final isRecordingUIActive = false.obs; // Controls the recording UI visibility
  
  final recordDurationMs = 0.obs;
  final hasText = false.obs; // NEW: Reactive variable to check for text

  // Speech-to-text
  late stt.SpeechToText _speech;

  // Simulated recorder state
  DateTime? _recordStart;
  String? _tempRecordingPath;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
    // NEW: Listen to changes in the text field to update the hasText variable
    inputCtrl.addListener(() {
      hasText.value = inputCtrl.text.trim().isNotEmpty;
    });
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    try {
      _speech.stop();
    } catch (_) {}
    _timer?.cancel();
    super.onClose();
  }

  void toggleAttachment() => isAttachmentOpen.toggle();

  void sendMessage([String? msg]) {
    final text = (msg ?? inputCtrl.text).trim();
    if (text.isEmpty) return;

    messages.add(Message.textMsg(text, isUser: true));
    inputCtrl.clear();

    Future.delayed(const Duration(milliseconds: 500), () {
      messages.add(Message.textMsg("Bot reply to: $text", isUser: false));
    });
  }

  // ---------- Speech-to-Text (ChatGPT style) ----------
  Future<void> startListening() async {
    if (isListening.value) return;

    final mic = await Permission.microphone.request();
    if (mic.isDenied || mic.isPermanentlyDenied) {
      _snack("Microphone permission is required");
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
        _snack("Speech recognizer not available");
        return;
      }

      inputCtrl.text = "";
      isListening.value = true;

      _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            inputCtrl.text = result.recognizedWords;
            inputCtrl.selection = TextSelection.fromPosition(
              TextPosition(offset: inputCtrl.text.length),
            );
          }
        },
      );
    } catch (e) {
      log("STT init error: $e");
      _snack("Speech recognition failed to start");
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

  // ---------- Voice Note (WhatsApp style) ----------
  Future<void> startVoiceRecord() async {
    if (isRecording.value) return;

    final mic = await Permission.microphone.request();
    if (mic.isDenied || mic.isPermanentlyDenied) {
      _snack("Microphone permission is required");
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a";

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
          recordDurationMs.value = DateTime.now().difference(_recordStart!).inMilliseconds;
        }
      });
    } catch (e) {
      log("startVoiceRecord error: $e");
      _snack("Unable to start recording (simulated)");
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
        messages.add(Message.voiceMsg(path: path, durationMs: durMs, isUser: true));

        Future.delayed(const Duration(milliseconds: 500), () {
          messages.add(Message.textMsg("Got your voice note 🎧", isUser: false));
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
      _snack("Recording failed");
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
      _snack("Camera permission is required");
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
    Get.showSnackbar(GetSnackBar(
      message: msg,
      duration: const Duration(seconds: 2),
    ));
  }
}