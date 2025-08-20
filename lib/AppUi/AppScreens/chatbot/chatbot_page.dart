// chat_bot_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Controllers/chatbot_controller.dart';
import '../../Models/message_model.dart';
import '../../AppScreens/chatbot/ChatBotWidgets/chat_sidebar.dart';
import '../../AppScreens/chatbot/ChatBotWidgets/attachment_box.dart';
import '../../AppScreens/chatbot/ChatBotWidgets/chat_input_field.dart';
import '../../Common_Widget/top_app_bar.dart'; 
import 'ChatBotWidgets/VoiceRecordingPanel.dart';
class ChatBotPage extends StatelessWidget {
  const ChatBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatBotController c = Get.find();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const ChatSidebar(),
      appBar: const TopAppBar(), // Use the reusable TopAppBar
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: EdgeInsets.all(12.w),
                itemCount: c.messages.length,
                reverse: false,
                itemBuilder: (context, index) {
                  final Message msg = c.messages[index];
                  return _buildMessageBubble(msg);
                },
              );
            }),
          ),
          Obx(() => c.isAttachmentOpen.value
              ? const AttachmentBox()
              : const SizedBox.shrink()),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 10.w, right: 10.w, bottom: 12.h, top: 6.h),
              child: Obx(() {
                final isRecordingUIActive = c.isRecordingUIActive.value;

                if (isRecordingUIActive) {
                  return const VoiceRecordingPanel();
                } else {
                  return Row(
                    children: [
                      Obx(() => Container(
                            width: 42.w,
                            height: 42.w,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 242, 242),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                c.isAttachmentOpen.value
                                    ? Icons.close
                                    : Icons.add,
                                color: Colors.black54,
                                size: 22.w,
                              ),
                              onPressed: () => c.toggleAttachment(),
                            ),
                          )),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ChatInputField(
                          borderColor: Colors.grey.shade300,
                          textColor: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 243, 242, 242),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Image.asset('assets/images/a.png'),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message msg) {
    final isUser = msg.isUser;
    final bg = isUser ? Colors.blue : Colors.grey.shade200;
    final textColor = isUser ? Colors.white : Colors.black87;
    final borderRadius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.zero,
          )
        : BorderRadius.circular(12);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.all(12.w),
        constraints: BoxConstraints(maxWidth: 0.78.sw),
        decoration: BoxDecoration(color: bg, borderRadius: borderRadius),
        child: msg.audioPath != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, color: textColor, size: 18.w),
                  SizedBox(width: 8.w),
                  Text(_formatDuration(msg.audioDurationMs ?? 0),
                      style:
                          TextStyle(color: textColor, fontSize: 14.sp)),
                ],
              )
            : Text(msg.text,
                style:
                    TextStyle(color: textColor, fontSize: 14.sp)),
      ),
    );
  }

  String _formatDuration(int ms) {
    final seconds = (ms / 1000).round();
    if (seconds < 60) return "$seconds s";
    final mins = seconds ~/ 60;
    final sec = seconds % 60;
    return "${mins}m ${sec}s";
  }
}