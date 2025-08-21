import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Controllers/chatbot_controller.dart';

class AttachmentBox extends StatelessWidget {
  const AttachmentBox({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChatBotController>();

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: 120.w, 
        margin: EdgeInsets.only(left: 12.w, bottom: 2.h), 
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
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
                  Icon(Icons.camera_alt, size: 18.w, color: Colors.black),
                  SizedBox(width: 8.w),
                  Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 10.h, color: Colors.grey[300]),

            InkWell(
              onTap: c.pickDocument,
              child: Row(
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    size: 18.w,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Document",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
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
