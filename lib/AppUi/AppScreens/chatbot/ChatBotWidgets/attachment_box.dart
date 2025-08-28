import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Controllers/chatbot_controller.dart';

class AttachmentBox extends StatelessWidget {
  const AttachmentBox({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChatBotController>();
    final isDarkMode = Get.isDarkMode;

    final boxColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final dividerColor = isDarkMode ? Colors.grey[600] : Colors.grey[300];

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: 120.w, 
        margin: EdgeInsets.only(left: 12.w, bottom: 2.h), 
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: c.pickFromCamera,
              child: Row(
                children: [
                  Icon(Icons.camera_alt, size: 18.w, color: iconColor),
                  SizedBox(width: 8.w),
                  Text(
                    "Camera".tr, // Corrected key to lowercase
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 10.h, color: dividerColor),

            InkWell(
              onTap: c.pickDocument,
              child: Row(
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    size: 18.w,
                    color: iconColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Document".tr, // Corrected key to lowercase
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}