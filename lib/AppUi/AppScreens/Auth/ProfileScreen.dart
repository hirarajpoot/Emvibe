import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import 'package:emvibe/AppUi/AppScreens/chatbot/chatbot_page.dart'; 
import 'package:emvibe/AppUi/Controllers/chatbot_controller.dart'; 
import 'package:emvibe/AppUi/AppScreens/chatbot/PersonaSettingsPage.dart';
import 'package:emvibe/AppUi/AppScreens/Auth/GeneralSettingsPage.dart';
import 'package:emvibe/AppUi/Controllers/GeneralSettingsController.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Color _generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(200) + 50,
      random.nextInt(200) + 50,
      random.nextInt(200) + 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String userName = "Guest";
    String userEmail = "Not Logged In";
    String firstLetter = 'G';
    Color avatarColor = Colors.grey.shade600;

    if (user != null) {
      userName = user.displayName ?? user.email?.split('@')[0] ?? "User Name";
      userEmail = user.email ?? "No Email";
      firstLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
      avatarColor = _generateRandomColor();
    }

    final ChatBotController chatController = Get.find<ChatBotController>();
    final settingsController = Get.find<GeneralSettingsController>();

    return Obx(() {
      final isDark = settingsController.isDarkMode.value;
      final backgroundColor = isDark ? Colors.black : Colors.grey.shade100;
      final textColor = isDark ? Colors.white : Colors.black;
      final cardColor = isDark ? Colors.grey.shade900 : Colors.white;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor, size: 24.w),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            "profile".tr, // ✅ translated
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: textColor),
          ),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("account".tr, textColor),
              _buildProfileCard(firstLetter, avatarColor, userName, userEmail, context, cardColor, textColor),
              SizedBox(height: 20.h),

              _buildSectionHeader("settings".tr, textColor),
              _buildSettingsItem(context, Icons.tune, "general_settings".tr, () {
                Get.to(() => const GeneralSettingsPage());
              }, cardColor, textColor),
              _buildSettingsItem(context, Icons.security, "security".tr, () {}, cardColor, textColor),
              _buildSettingsItem(context, Icons.credit_card, "subscriptions".tr, () {}, cardColor, textColor),
              SizedBox(height: 20.h),

              _buildSectionHeader("advanced".tr, textColor),
              _buildSettingsItem(context, Icons.visibility_off, "incognito_chat".tr, () {
                chatController.startIncognitoChat();
                Get.back();
                Get.to(() => const ChatBotPage());
              }, cardColor, textColor),
              _buildSettingsItem(context, Icons.palette_outlined, "change_persona".tr, () {
                Get.back();
                Get.to(() => const PersonaSettingsPage());
              }, cardColor, textColor),
              _buildSettingsItem(context, Icons.phone, "phone_number".tr, () {}, cardColor, textColor),
              _buildSettingsItem(context, Icons.info_outline, "about".tr, () {}, cardColor, textColor),
              SizedBox(height: 20.h),

              _buildSettingsItem(
                context,
                Icons.logout,
                "logout".tr,
                () {
                  Get.defaultDialog(
                    backgroundColor: cardColor,
                    title: "logout".tr,
                    titleStyle: TextStyle(color: textColor, fontSize: 18.sp, fontWeight: FontWeight.bold),
                    middleText: "logout_confirm".tr,
                    middleTextStyle: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14.sp),
                    textConfirm: "logout".tr,
                    textCancel: "cancel".tr,
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.blue,
                    cancelTextColor: textColor,
                    onConfirm: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.back();
                      Get.offAllNamed('/login');
                    },
                    onCancel: () => Get.back(),
                  );
                },
                cardColor,
                Colors.red,
                iconColor: Colors.red,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: textColor.withOpacity(0.7),
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      String firstLetter,
      Color avatarColor,
      String userName,
      String userEmail,
      BuildContext context,
      Color cardColor,
      Color textColor) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: avatarColor,
              child: Text(
                firstLetter,
                style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 14.sp, color: textColor.withOpacity(0.7)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: textColor.withOpacity(0.6), size: 20.w),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      Color cardColor,
      Color textColor, {
        Color? iconColor,
      }) {
    return Card(
      color: cardColor,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? textColor, size: 22.w),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, color: textColor),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: textColor.withOpacity(0.5), size: 16.w),
        onTap: onTap,
      ),
    );
  }
}
