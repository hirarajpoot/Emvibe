import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import 'package:emvibe/AppUi/AppScreens/chatbot/chatbot_page.dart'; 
import 'package:emvibe/AppUi/Controllers/chatbot_controller.dart'; 
import 'package:emvibe/AppUi/AppScreens/chatbot/PersonaSettingsPage.dart';
import 'package:emvibe/AppUi/AppScreens/Auth/GeneralSettingsPage.dart'; // 🔥 Naya import

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

    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w), 
          onPressed: () {
            Get.back(); 
          },
        ),
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black, 
        foregroundColor: Colors.white, 
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Account Section
            _buildSectionHeader("ACCOUNT"),
            _buildProfileCard(firstLetter, avatarColor, userName, userEmail, context),
            SizedBox(height: 20.h),

            // Settings Section
            _buildSectionHeader("SETTINGS"),
            // 🔥 Yahan GeneralSettingsPage par navigate karwaya gaya hai
            _buildSettingsItem(context, Icons.tune, "General Settings", () {
              Get.to(() => const GeneralSettingsPage());
            }),
            _buildSettingsItem(context, Icons.security, "Security", () {
              // No snackbar, silent operation
            }),
            _buildSettingsItem(context, Icons.credit_card, "Subscriptions", () {
              // No snackbar, silent operation
            }),
            SizedBox(height: 20.h),

            // Advanced Features Section
            _buildSectionHeader("ADVANCED"),
            _buildSettingsItem(context, Icons.visibility_off, "Incognito Chat", () {
              chatController.startIncognitoChat(); 
              Get.back(); 
              Get.to(() => const ChatBotPage()); 
            }),
            _buildSettingsItem(context, Icons.palette_outlined, "Change Persona", () {
              Get.back(); // Profile screen close karein
              Get.to(() => const PersonaSettingsPage()); // PersonaSettingsPage par navigate karein
            }),
            _buildSettingsItem(context, Icons.phone, "Phone Number", () {
              // No snackbar, silent operation
            }),
            _buildSettingsItem(context, Icons.info_outline, "About", () {
              // No snackbar, silent operation
            }),
            SizedBox(height: 20.h),

            // Logout Button
            _buildSettingsItem(context, Icons.logout, "Logout", () {
              Get.defaultDialog(
                backgroundColor: Colors.grey.shade900,
                title: "Logout",
                titleStyle: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                middleText: "Are you sure you want to log out?",
                middleTextStyle: TextStyle(color: Colors.white70, fontSize: 14.sp),
                textConfirm: "Logout",
                textCancel: "Cancel",
                confirmTextColor: Colors.white,
                buttonColor: Colors.blue, 
                cancelTextColor: Colors.white,
                onConfirm: () async {
                  await FirebaseAuth.instance.signOut(); 
                  Get.back(); 
                  Get.offAllNamed('/login'); 
                },
                onCancel: () => Get.back(),
              );
            }, iconColor: Colors.red, textColor: Colors.red), 
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileCard(String firstLetter, Color avatarColor, String userName, String userEmail, BuildContext context) {
    return Card(
      color: Colors.grey.shade900, 
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
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white54, size: 20.w),
              onPressed: () {
                // No snackbar, silent operation
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color iconColor = Colors.white, Color textColor = Colors.white}) {
    return Card(
      color: Colors.grey.shade900, 
      margin: EdgeInsets.symmetric(vertical: 4.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 22.w),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, color: textColor),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16.w),
        onTap: onTap,
      ),
    );
  }
}
