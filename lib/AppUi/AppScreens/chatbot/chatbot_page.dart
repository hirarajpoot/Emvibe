import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Controllers/chatbot_controller.dart';
import '../../Controllers/GeneralSettingsController.dart';
import '../../Models/message_model.dart';
import '../../AppScreens/chatbot/ChatBotWidgets/chat_sidebar.dart';
import '../../AppScreens/chatbot/ChatBotWidgets/attachment_box.dart';
import '../../AppScreens/chatbot/ChatBotWidgets/chat_input_field.dart';
import '../../Common_Widget/top_app_bar.dart';
import 'ChatBotWidgets/VoiceRecordingPanel.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  Message? _selectedMessage;

  @override
  Widget build(BuildContext context) {
    final ChatBotController c = Get.find();
    final GeneralSettingsController settingsController = Get.find<GeneralSettingsController>();

    return Obx(() {
      final isDarkMode = settingsController.isDarkMode.value;
      final textColor = isDarkMode ? Colors.white : Colors.black;
      final bubbleColorUser = isDarkMode ? Colors.blue.shade700 : Colors.blue;
      final bubbleColorBot = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;
      final backgroundPath = settingsController.customBackgroundPath.value;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        resizeToAvoidBottomInset: true,
        drawer: const ChatSidebar(),
        appBar: const TopAppBar(),
        body: GestureDetector(
          onTap: () {
            setState(() {
              _selectedMessage = null;
            });
          },
          child: Container(
            decoration: backgroundPath.isNotEmpty
                ? BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(backgroundPath)),
                      fit: BoxFit.cover,
                    ),
                  )
                : BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                  ),
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      padding: EdgeInsets.all(12.w),
                      itemCount: c.messages.length,
                      reverse: false,
                      itemBuilder: (context, index) {
                        final Message msg = c.messages[index];
                        return _buildMessageBubble(msg, c, bubbleColorUser, bubbleColorBot, textColor);
                      },
                    );
                  }),
                ),
                Obx(() {
                  if (c.isBotTyping.value) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "typing_indicator".tr,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                              fontSize: 14.sp
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                Obx(() => c.isAttachmentOpen.value
                    ? const AttachmentBox()
                    : const SizedBox.shrink()),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.w, right: 10.w, bottom: 12.h, top: 6.h),
                    child: Obx(() {
                      if (c.isRecordingUIActive.value) {
                        return const VoiceRecordingPanel();
                      } else {
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 2.h),
                                width: 42.w,
                                height: 42.w,
                                decoration: BoxDecoration(
                                  color: isDarkMode ? Colors.grey.shade800 : const Color.fromARGB(255, 243, 242, 242),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    c.isAttachmentOpen.value
                                        ? Icons.close
                                        : Icons.add,
                                    color: isDarkMode ? Colors.white70 : Colors.black54,
                                    size: 22.w,
                                  ),
                                  onPressed: () => c.toggleAttachment(),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: ChatInputField(
                                  controller: c.textController,
                                  borderColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                                  textColor: textColor,
                                  hintText: 'type_message_hint'.tr,
                                  onSubmitted: (value) => c.sendMessage(),
                                  suffixIcon: Obx(() => IconButton(
                                        icon: Icon(
                                          c.isListening.value ? Icons.mic : Icons.mic_none,
                                          color: c.isListening.value
                                              ? Colors.blue.shade700
                                              : (isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500),
                                        ),
                                        onPressed: c.speechEnabled.value
                                            ? (c.isListening.value ? c.stopListening : c.startListening)
                                            : null,
                                      )),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onLongPressStart: (_) => c.startVoiceRecord(),
                                onLongPressEnd: (_) => c.stopVoiceRecord(send: true),
                                onTap: () {
                                  if (c.hasText.value) {
                                    c.sendMessage();
                                  } else {
                                    c.startVoiceRecord();
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 2.h),
                                  width: 42.w,
                                  height: 42.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: c.hasText.value
                                        ? Colors.blue.shade600
                                        : (isDarkMode ? Colors.grey.shade800 : const Color.fromARGB(255, 243, 242, 242)),
                                  ),
                                  child: c.hasText.value
                                      ? Icon(Icons.send, color: Colors.white, size: 22.w)
                                      : Center(
                                            child: SizedBox(
                                              width: 24.w,
                                              height: 24.w,
                                              child: Image.asset(
                                                'assets/images/a.png',
                                                color: isDarkMode ? Colors.white70 : null,
                                              ),
                                            ),
                                          ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMessageBubble(Message msg, ChatBotController c, Color userBubbleColor, Color botBubbleColor, Color textColor) {
    final isUser = msg.isUser;
    final bg = isUser ? userBubbleColor : botBubbleColor;
    final bubbleTextColor = isUser ? Colors.white : textColor;
    final borderRadius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.zero,
          )
        : BorderRadius.circular(12);

    final showSaveIcon = !isUser && msg == _selectedMessage;

    final GeneralSettingsController settingsController = Get.find();
    final isDarkMode = settingsController.isDarkMode.value;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: !isUser
            ? () {
                setState(() {
                  _selectedMessage = msg;
                });
              }
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 6.h),
              padding: EdgeInsets.all(12.w),
              constraints: BoxConstraints(maxWidth: 0.78.sw - (showSaveIcon ? 40.w : 0)),
              decoration: BoxDecoration(color: bg, borderRadius: borderRadius),
              child: msg.type == MessageType.voice
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, color: bubbleTextColor, size: 18.w),
                        SizedBox(width: 8.w),
                        Text(_formatDuration(msg.audioDurationMs ?? 0),
                            style: TextStyle(color: bubbleTextColor, fontSize: 14.sp)),
                      ],
                    )
                  : msg.type == MessageType.image
                      ? Image.file(
                          File(msg.path!),
                          width: 200.w,
                          height: 200.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Text("image_failed".tr, style: TextStyle(color: bubbleTextColor)))
                      : msg.type == MessageType.file
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.insert_drive_file, color: bubbleTextColor, size: 18.w),
                                SizedBox(width: 8.w),
                                Text(msg.fileName ?? "file".tr, style: TextStyle(color: bubbleTextColor, fontSize: 14.sp)),
                              ],
                            )
                          : Text(msg.text,
                              style: TextStyle(color: bubbleTextColor, fontSize: 14.sp)),
            ),
            if (showSaveIcon)
              Padding(
                padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
                child: Obx(() {
                  final isSaved = c.savedMessages.contains(msg);
                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved
                          ? Colors.blue 
                          : isDarkMode
                              ? Colors.white 
                              : Colors.black, 
                      size: 20.w,
                    ),
                    onPressed: () {
                      if (isSaved) {
                        c.deleteSavedMessage(msg);
                      } else {
                        c.saveMessage(msg);
                      }
                      setState(() {
                        _selectedMessage = null;
                      });
                    },
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int ms) {
    final seconds = (ms / 1000).round();
    if (seconds < 60) return "$seconds ${'seconds_short'.tr}";
    final mins = seconds ~/ 60;
    final sec = seconds % 60;
    return "${mins}${'minutes_short'.tr} ${sec}${'seconds_short'.tr}";
  }
}