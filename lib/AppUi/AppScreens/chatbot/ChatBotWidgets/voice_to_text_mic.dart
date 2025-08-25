import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Controllers/chatbot_controller.dart';

class VoiceToTextMic extends StatelessWidget {
  const VoiceToTextMic({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatBotController c = Get.find();

    return Obx(() {
      final isListening = c.isListening.value;

      return GestureDetector(
        onTap: () {
          if (isListening) {
            c.stopListening(); 
          } else {
            c.startListening(); 
          }
        },
        child: Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isListening ? Colors.blue : const Color.fromARGB(255, 243, 242, 242),
          ),
          child: Icon(
            Icons.mic,
            color: isListening ? Colors.white : Colors.black54,
            size: 22.w,
          ),
        ),
      );
    });
  }
}
