import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  late final stt.SpeechToText _speechToText;
  final RxBool speechEnabled;
  final RxBool isListening;
  final RxString recognizedText;
  final TextEditingController textController;
  final Future<void> Function({bool send}) onRecordStop;

  SpeechService({
    required this.speechEnabled,
    required this.isListening,
    required this.recognizedText,
    required this.textController,
    required this.onRecordStop,
  }) {
    _speechToText = stt.SpeechToText();
    _initSpeechToText();
  }

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
  }

  Future<void> startListening() async {
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
    } catch (_) {}
    isListening.value = false;
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    recognizedText.value = result.recognizedWords;
    textController.text = recognizedText.value;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );
  }

  void dispose() {
    try {
      _speechToText.stop();
    } catch (_) {}
  }
}