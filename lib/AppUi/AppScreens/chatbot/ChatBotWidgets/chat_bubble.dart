import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({super.key, required this.message});

  String _formatDuration(int ms) {
    final s = (ms / 1000).floor();
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return "$m:$ss";
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final isVoice = message.audioPath != null;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade200,
          borderRadius: isUser
              ? BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.zero,
                )
              : BorderRadius.circular(12.r),
        ),
        child: isVoice
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mic,
                    size: 18.sp,
                    color: isUser ? Colors.white : Colors.black87,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _formatDuration(message.audioDurationMs ?? 0),
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "(saved)",
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.black54,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              )
            : Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15.sp,
                ),
              ),
      ),
    );
  }
}
