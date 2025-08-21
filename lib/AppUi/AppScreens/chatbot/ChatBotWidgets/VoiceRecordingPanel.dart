import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Controllers/chatbot_controller.dart';

class VoiceRecordingPanel extends StatelessWidget {
  const VoiceRecordingPanel({super.key});

  String _formatDuration(int milliseconds) {
    int seconds = (milliseconds / 1000).round();
    String minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    String remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChatBotController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      child: Row(
        children: [
          InkWell(
            onTap: c.cancelVoiceRecord,
            borderRadius: BorderRadius.circular(21.w),
            child: Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 243, 242, 242),
              ),
              child: Icon(Icons.delete_outline, color: Colors.red, size: 22.w),
            ),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    _formatDuration(c.recordDurationMs.value),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                Container(
                  height: 30.w,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Recording...",
                      style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          InkWell(
            onTap: () => c.stopVoiceRecord(send: true),
            borderRadius: BorderRadius.circular(21.w),
            child: Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade600,
              ),
              child: Icon(Icons.send, color: Colors.white, size: 22.w),
            ),
          ),
        ],
      ),
    );
  }
}