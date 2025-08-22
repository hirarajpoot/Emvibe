import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Controllers/chatbot_controller.dart';
import '../AppScreens/chatbot/PersonaSettingsPage.dart'; // 🔥 NEW: PersonaSettingsPage ko import karein

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatBotController>();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leadingWidth: 110.w,
      leading: Builder(
        builder: (context) => Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black54, size: 26),
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
      title: null,
      centerTitle: false,

      // RIGHT SIDE - TIGHTER SPACING
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Settings Icon
            IconButton(
              icon: Icon(Icons.settings, color: Colors.black54, size: 22),
              onPressed: () {
                // 🔥 FIX: Directly navigate to PersonaSettingsPage, no snackbar
                Get.to(() => const PersonaSettingsPage());
              },
              padding: EdgeInsets.only(right: 8.w), // Reduced padding
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),

            // Notification Icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_none,
                    color: Colors.black54,
                    size: 24,
                  ),
                  onPressed: () {
                    // Removed snackbar here as per previous instructions
                  },
                  padding: EdgeInsets.only(right: 8.w), // Reduced padding
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
                Positioned(
                  right: 10.w, // Adjusted position
                  top: 6.h,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12.w,
                      minHeight: 12.w,
                    ),
                    child: Text(
                      '2',
                      style: TextStyle(color: Colors.white, fontSize: 8.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),

            // Avatar
            Padding(
              padding: EdgeInsets.only(right: 8.w), // Reduced padding
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.orange,
                child: Text(
                  "M",
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              ),
            ),

            // New Chat Button - Moved closer to other icons
            Container(
              margin: EdgeInsets.only(right: 12.w), // Reduced margin
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
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
