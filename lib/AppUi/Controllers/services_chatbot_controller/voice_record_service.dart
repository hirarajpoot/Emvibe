import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import '../../Models/message_model.dart';
import '../GeneralSettingsController.dart';
import '../../AppScreens/ProfileScreen/GeneralSettings/widgets/notification_service.dart';
import 'package:translator/translator.dart';

class VoiceRecordService {
  late AudioRecorder _audioRecorder;
  final RxBool isRecording;
  final RxBool isRecordingUIActive;
  final RxInt recordDurationMs;
  final RxList<Message> messages;
  final RxBool isBotTyping;
  final RxString userLanguage;
  final NotificationService notificationService = Get.find();
  final GeneralSettingsController settingsController = Get.find();
  final RxBool isAppInForeground;
  final translator = GoogleTranslator();

  DateTime? _recordStart;
  String? _tempRecordingPath;
  Timer? _timer;

  VoiceRecordService({
    required this.isRecording,
    required this.isRecordingUIActive,
    required this.recordDurationMs,
    required this.messages,
    required this.isBotTyping,
    required this.userLanguage,
    required this.isAppInForeground,
  }) {
    _audioRecorder = AudioRecorder();
  }

  Future<void> startVoiceRecord() async {
    if (isRecording.value) return;

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
        String translatedText = await _translateText("Got your voice note 🎧", userLanguage.value);
        messages.add(
          Message.textMsg(translatedText, isUser: false),
        );
        isBotTyping.value = false;

        if (!isAppInForeground.value && settingsController.notificationsEnabled.value) {
          notificationService.showChatbotNotification('Voice Note Processed!', 'The chatbot has a new message for you.');
        }
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

  Future<String> _translateText(String text, String targetLang) async {
    try {
      final translation = await translator.translate(text, to: targetLang);
      return translation.text;
    } catch (e) {
      log('Error translating text: $e');
      return text;
    }
  }

  void dispose() {
    try {
      _audioRecorder.dispose();
    } catch (_) {}
    _timer?.cancel();
  }
}