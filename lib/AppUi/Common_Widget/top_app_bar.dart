import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Firebase Auth ki ab yahan zaroorat nahi, isko remove kar diya
// import 'package:firebase_auth/firebase_auth.dart'; 

// 🔥 Corrected import paths
import 'package:emvibe/AppUi/Controllers/chatbot_controller.dart';
import 'package:emvibe/AppUi/AppScreens/chatbot/PersonaSettingsPage.dart'; 

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 ChatBotController ab theek se pehchana jayega
    final chatController = Get.find<ChatBotController>();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leadingWidth: 110.w,
      leading: Builder(
        builder: (context) => Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black54, size: 26),
              onPressed: () => Scaffold.of(context).openDrawer(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: Colors.yellow.shade200,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              "Miley",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      // 🔥 Title ko update kiya, yeh incognito status bhi dikhaega
      title: Obx(() => Column( 
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // 🔥 Yahan "Miley AI Chat" hata diya gaya hai
                chatController.currentChatSessionIndex.value == -1
                    ? ""
                    : chatController.getSortedChatSessions()[chatController.currentChatSessionIndex.value].customTitle.value,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (chatController.isCurrentSessionIncognito.value) 
                Text(
                  "Incognito",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.sp,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          )),
      centerTitle: false,

      actions: [
        // Settings aur Notification icons yahan se hata diye gaye hain
        
        // New Chat Button 
        Container(
          margin: EdgeInsets.only(right: 12.w), 
          child: ElevatedButton(
            onPressed: () {
              chatController.startNewChat();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 4.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              elevation: 0,
              minimumSize: Size(60.w, 28.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "New Chat",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
