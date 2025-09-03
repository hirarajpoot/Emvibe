import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emvibe/AppUi/Controllers/chatbot_controller.dart';
// import 'package:emvibe/AppUi/AppScreens/chatbot/PersonaSettingsPage.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatBotController>();
    final isDarkMode = Get.isDarkMode;

    final appBarColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final iconColor = isDarkMode ? Colors.white : Colors.black54;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final incognitoColor = isDarkMode ? Colors.grey[400] : Colors.grey.shade600;

    return AppBar(
      backgroundColor: appBarColor,
      elevation: 0.5,
      leadingWidth: 110.w,
      leading: Builder(
        builder: (context) => Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: iconColor, size: 26),
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
              "app_name".tr,
              style: TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      title: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatController.currentChatSessionIndex.value == -1
                    ? "" // Removed "new_chat_title" text
                    : chatController.getSortedChatSessions()[chatController.currentChatSessionIndex.value].customTitle.value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (chatController.isCurrentSessionIncognito.value)
                SizedBox.shrink(), // Removed "incognito" text
            ],
          )),
      centerTitle: false,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 6.w),
          child: ElevatedButton(
            onPressed: () {
              chatController.startNewIncognitoChat();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade600,
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
              "incognito".tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
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
              "new_chat".tr,
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