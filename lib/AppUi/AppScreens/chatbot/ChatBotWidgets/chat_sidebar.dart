import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import '../../chatbot/chatbot_page.dart';
import '../../DashboardScreen/dashboard_screen.dart';
import '../../../Controllers/chatbot_controller.dart';
import '../../../Controllers/GeneralSettingsController.dart';
import '../../ProfileScreen/ProfileScreen.dart';

class ChatSidebar extends StatelessWidget {
  const ChatSidebar({super.key});

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
    final ChatBotController c = Get.find();
    final GeneralSettingsController settingsController = Get.find<GeneralSettingsController>();

    return Obx(() {
      final isDarkMode = settingsController.isDarkMode.value;
      final backgroundColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
      final textIconColor = isDarkMode ? Colors.white : Colors.black;
      final sectionTextColor = isDarkMode ? Colors.white70 : Colors.black87;
      final tileSelectedColor = isDarkMode ? Colors.blue.shade800 : Colors.blue.shade100;

      return Drawer(
        child: Container(
          color: backgroundColor,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "app_name".tr, // Fixed translation
                                    style: TextStyle(
                                      color: textIconColor,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: textIconColor),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: textIconColor.withOpacity(0.2), height: 1.h),

                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                            child: Text(
                              "main".tr, // Fixed translation
                              style: TextStyle(color: sectionTextColor, fontSize: 12.sp),
                            ),
                          ),
                          _sidebarItem(
                              context,
                              Icons.chat_bubble_outline,
                              "Chatbot".tr, // Fixed translation
                              () {
                                Navigator.of(context).pop();
                                Get.to(() => const ChatBotPage());
                              },
                              textIconColor: textIconColor
                              ),

                          Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: textIconColor,
                              expansionTileTheme: ExpansionTileThemeData(
                                iconColor: textIconColor,
                                textColor: textIconColor,
                                collapsedIconColor: textIconColor,
                                collapsedTextColor: textIconColor,
                              ),
                            ),
                            child: ExpansionTile(
                              leading: Icon(Icons.history, color: textIconColor),
                              title: Text("recent_chats".tr, style: TextStyle(color: textIconColor)), // Fixed translation
                              childrenPadding: EdgeInsets.only(left: 20.w),
                              children: [
                                Obx(() {
                                  final sortedChatSessions = c.getSortedChatSessions();
                                  if (sortedChatSessions.isEmpty) {
                                    return _sidebarItem(
                                        context, Icons.info_outline, "no_recent_chats".tr, () {}, // Fixed translation
                                        textIconColor: textIconColor
                                        );
                                  }
                                  return Column(
                                    children: List.generate(sortedChatSessions.length, (index) {
                                      final chatSession = sortedChatSessions[index];

                                      final isSelected = c.currentChatSessionIndex.value != -1 &&
                                          c.chatHistory.isNotEmpty &&
                                          c.chatHistory[c.currentChatSessionIndex.value].id == chatSession.id;

                                      return Obx(() => _sidebarItem(
                                            context,
                                            chatSession.isPinned.value ? Icons.push_pin : Icons.message,
                                            chatSession.customTitle.value,
                                            () {
                                              final originalIndex = c.chatHistory.indexOf(chatSession);
                                              if (originalIndex != -1) {
                                                c.loadChatFromHistory(originalIndex);
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            isSelected: isSelected,
                                            textIconColor: textIconColor,
                                            selectedColor: tileSelectedColor,
                                            trailing: PopupMenuButton<String>(
                                              icon: Icon(Icons.more_vert, color: textIconColor, size: 20.w),
                                              onSelected: (String result) {
                                                switch (result) {
                                                  case 'share':
                                                    c.shareChatSession(chatSession);
                                                    break;
                                                  case 'rename':
                                                    final TextEditingController renameController =
                                                        TextEditingController(text: chatSession.customTitle.value);
                                                    Get.defaultDialog(
                                                      backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                                                      title: "rename_chat".tr, // Fixed translation
                                                      titleStyle: TextStyle(
                                                          color: textIconColor, fontSize: 18.sp, fontWeight: FontWeight.bold),
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          TextField(
                                                            controller: renameController,
                                                            autofocus: true,
                                                            cursorColor: textIconColor,
                                                            style: TextStyle(color: textIconColor, fontSize: 16.sp),
                                                            decoration: InputDecoration(
                                                              hintText: "enter_new_chat_name".tr, // Fixed translation
                                                              hintStyle: TextStyle(color: textIconColor.withOpacity(0.6)),
                                                              enabledBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(color: textIconColor.withOpacity(0.5))),
                                                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      textConfirm: "rename".tr, // Fixed translation
                                                      textCancel: "cancel".tr, // Fixed translation
                                                      confirmTextColor: Colors.white,
                                                      buttonColor: Colors.blue,
                                                      cancelTextColor: textIconColor,
                                                      onConfirm: () {
                                                        if (renameController.text.trim().isNotEmpty) {
                                                          c.renameChatSession(chatSession, renameController.text.trim());
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      onCancel: () {
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                    break;
                                                  case 'pin_unpin':
                                                    c.togglePinStatus(chatSession);
                                                    break;
                                                  case 'delete':
                                                    Get.defaultDialog(
                                                      backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                                                      title: "delete_chat".tr, // Fixed translation
                                                      titleStyle: TextStyle(
                                                          color: textIconColor, fontSize: 18.sp, fontWeight: FontWeight.bold),
                                                      middleText: "delete_chat_confirm".tr, // Fixed translation
                                                      middleTextStyle: TextStyle(color: textIconColor, fontSize: 14.sp),
                                                      textConfirm: "delete".tr, // Fixed translation
                                                      textCancel: "cancel".tr, // Fixed translation
                                                      confirmTextColor: Colors.white,
                                                      buttonColor: Colors.blue,
                                                      cancelTextColor: textIconColor,
                                                      onConfirm: () {
                                                        c.deleteChatSession(chatSession);
                                                        Navigator.pop(context);
                                                      },
                                                      onCancel: () {
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                    break;
                                                }
                                              },
                                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                  value: 'share',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.share, color: textIconColor, size: 18.w),
                                                      SizedBox(width: 8.w),
                                                      Text('share'.tr, style: TextStyle(color: textIconColor)), // Fixed translation
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem<String>(
                                                  value: 'pin_unpin',
                                                  child: Obx(() => Row(
                                                        children: [
                                                          Icon(
                                                            chatSession.isPinned.value ? Icons.push_pin_outlined : Icons.push_pin,
                                                            color: textIconColor,
                                                            size: 18.w,
                                                          ),
                                                          SizedBox(width: 8.w),
                                                          Text(
                                                            chatSession.isPinned.value ? 'unpin_chat'.tr : 'pin_chat'.tr, // Fixed translation
                                                            style: TextStyle(color: textIconColor),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                PopupMenuItem<String>(
                                                  value: 'rename',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit, color: textIconColor, size: 18.w),
                                                      SizedBox(width: 8.w),
                                                      Text('rename'.tr, style: TextStyle(color: textIconColor)), // Fixed translation
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete, color: textIconColor, size: 18.w),
                                                      SizedBox(width: 8.w),
                                                      Text('delete'.tr, style: TextStyle(color: textIconColor)), // Fixed translation
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                                            ),
                                          ));
                                    }),
                                  );
                                }),
                              ],
                            ),
                          ),
                          _sidebarItem(context, Icons.search, "search".tr, () { // Fixed translation
                            Navigator.of(context).pop();
                          }, textIconColor: textIconColor),
                          _sidebarItem(context, Icons.calendar_today, "calendar".tr, () {}, textIconColor: textIconColor), // Fixed translation
                          _sidebarItem(context, Icons.timeline, "activity".tr, () {}, textIconColor: textIconColor), // Fixed translation
                          _sidebarItem(context, Icons.menu, "menu".tr, () {}, textIconColor: textIconColor), // Fixed translation
                          _sidebarItem(context, Icons.book, "book".tr, () {}, textIconColor: textIconColor), // Fixed translation
                          SizedBox(height: 16.h),

                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                            child: Text("chat".tr, style: TextStyle(color: sectionTextColor, fontSize: 12.sp)), // Fixed translation
                          ),
                          _sidebarItem(context, Icons.forum_outlined, "session".tr, () {}, textIconColor: textIconColor), // Fixed translation
                          _sidebarItem(
                            context,
                            Icons.dashboard,
                            "dashboard".tr, // Fixed translation
                            () {
                              Navigator.of(context).pop();
                              Get.to(() => const DashboardScreen());
                            },
                            textIconColor: textIconColor,
                          ),
                          _sidebarItem(
                            context,
                            Icons.delete_forever,
                            "clear_all_chats".tr, // Fixed translation
                            () {
                              Get.defaultDialog(
                                backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                                title: "clear_all_chats_title".tr, // Fixed translation
                                titleStyle: TextStyle(color: textIconColor, fontSize: 18.sp, fontWeight: FontWeight.bold),
                                middleText: "clear_all_chats_message".tr, // Fixed translation
                                middleTextStyle: TextStyle(color: textIconColor, fontSize: 14.sp),
                                textConfirm: "clear_all".tr, // Fixed translation
                                textCancel: "cancel".tr, // Fixed translation
                                confirmTextColor: Colors.white,
                                buttonColor: Colors.blue,
                                cancelTextColor: textIconColor,
                                onConfirm: () {
                                  c.clearChatHistory();
                                  Navigator.pop(context);
                                },
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            textIconColor: textIconColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    String firstLetter = 'G';
                    Color avatarColor = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400;
                    String userName = "profile".tr; // Fixed translation
                    if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                      final User? user = snapshot.data;
                      if (user != null) {
                        if (user.displayName != null && user.displayName!.isNotEmpty) {
                          userName = user.displayName!;
                          firstLetter = user.displayName![0].toUpperCase();
                        } else if (user.email != null && user.email!.isNotEmpty) {
                          userName = user.email!.split('@')[0];
                          firstLetter = user.email![0].toUpperCase();
                        }
                        avatarColor = _generateRandomColor();
                      }
                    } else {
                      firstLetter = 'G';
                      avatarColor = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400;
                      userName = "guest".tr; // Fixed translation
                    }

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: avatarColor,
                        child: Text(
                          firstLetter,
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        userName,
                        style: TextStyle(color: textIconColor, fontSize: 16.sp),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => const ProfileScreen());
                      },
                      trailing: Icon(Icons.arrow_forward_ios, color: textIconColor.withOpacity(0.6), size: 16.w),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _sidebarItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isSelected = false,
    Widget? trailing,
    required Color textIconColor,
    Color? selectedColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textIconColor),
      title: Text(title, style: TextStyle(color: textIconColor)),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: selectedColor ?? Colors.blue.withOpacity(0.3),
      trailing: trailing,
    );
  }
}