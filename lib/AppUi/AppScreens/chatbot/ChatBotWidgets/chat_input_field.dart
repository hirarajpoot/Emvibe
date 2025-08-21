import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controllers/chatbot_controller.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController? controller;
  final Color borderColor;
  final Color textColor;

  const ChatInputField({
    super.key,
    this.controller,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChatBotController>();

    return Obx(() {
      final isRecording = c.isRecording.value;
      final hasText = c.hasText.value;

      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 80.h, // 👈 max 4 lines approx
        ),
        child: Scrollbar(
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: null, // allow multiple lines
            keyboardType: TextInputType.multiline,
            style: TextStyle(fontSize: 14.sp, color: textColor),
            decoration: InputDecoration(
              hintText: isRecording ? "🎤 Recording..." : "Type a message...",
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13.sp,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: borderColor, width: 1.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: borderColor, width: 1.5.w),
              ),
              suffixIcon: hasText
                  ? IconButton(
                      icon: Transform.rotate(
                        angle: -15 * math.pi / 180,
                        child: Icon(
                          Icons.send,
                          color: Colors.blue,
                          size: 22.sp,
                        ),
                      ),
                      onPressed: c.sendMessage,
                    )
                  : GestureDetector(
                      onLongPressStart: (_) {
                        if (c.isListening.value) {
                          c.stopListening();
                        }
                        c.startVoiceRecord();
                      },
                      onLongPressEnd: (_) => c.stopVoiceRecord(send: true),
                      child: Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isRecording
                                ? Colors.red
                                : const Color(0xFFF3F2F2),
                          ),
                          child: Icon(
                            isRecording ? Icons.mic : Icons.mic_none,
                            color: isRecording ? Colors.white : Colors.black54,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
            ),
            onSubmitted: (_) => c.sendMessage(),
          ),
        ),
      );
    });
  }
}
