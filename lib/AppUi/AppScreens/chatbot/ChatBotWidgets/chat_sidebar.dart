import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../chatbot/chatbot_page.dart';
import '../../DashboardScreen/dashboard_screen.dart';
import '../../../Controllers/chatbot_controller.dart';

class ChatSidebar extends StatelessWidget {
  const ChatSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatBotController c = Get.find();

    return Drawer(
      child: Container(
        color: Colors.black,
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
                                  "MyApp",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white70,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.white24, height: 1.h),

                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                          child: Text(
                            "MAIN",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        _sidebarItem(
                          context,
                          Icons.chat_bubble_outline,
                          "Chatbot",
                          () {
                            Navigator.of(context).pop();
                            Get.to(() => const ChatBotPage());
                          },
                        ),

                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white,
                            expansionTileTheme: const ExpansionTileThemeData(
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              collapsedTextColor: Colors.white,
                            ),
                          ),
                          child: ExpansionTile(
                            leading: Icon(Icons.history, color: Colors.white),
                            title: Text(
                              "Recent Chats",
                              style: const TextStyle(color: Colors.white),
                            ),
                            childrenPadding: EdgeInsets.only(left: 20.w),
                            children: [
                              Obx(() {
                                final chatSessions = c.getAllChatSessions();
                                if (chatSessions.isEmpty) {
                                  return _sidebarItem(
                                    context,
                                    Icons.info_outline,
                                    "No Recent Chats",
                                    () {
                                      // Removed snackbar here
                                    },
                                  );
                                }
                                return Column(
                                  children: List.generate(chatSessions.length, (
                                    index,
                                  ) {
                                    final firstUserMessage = chatSessions[index]
                                        .firstWhereOrNull(
                                          (msg) =>
                                              msg.isUser && msg.text.isNotEmpty,
                                        );

                                    final chatTitle =
                                        firstUserMessage != null &&
                                            firstUserMessage.text.isNotEmpty
                                        ? firstUserMessage.text.substring(
                                                0,
                                                firstUserMessage.text.length
                                                    .clamp(0, 25),
                                              ) +
                                              (firstUserMessage.text.length > 25
                                                  ? '...'
                                                  : '')
                                        : "Chat Session ${index + 1}";

                                    final isSelected =
                                        c.currentChatSessionIndex.value ==
                                        index;

                                    return _sidebarItem(
                                      context,
                                      Icons.message,
                                      chatTitle,
                                      () {
                                        c.loadChatFromHistory(index);
                                        Navigator.of(context).pop();
                                      },
                                      isSelected: isSelected,
                                      trailing: PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.white70,
                                          size: 20.w,
                                        ),
                                        onSelected: (String result) {
                                          switch (result) {
                                            case 'share':
                                              // Removed snackbar here
                                              break;
                                            case 'rename':
                                              // Removed snackbar here
                                              break;
                                            case 'pin':
                                              // Removed snackbar here
                                              break;
                                            case 'delete':
                                              Get.defaultDialog(
                                                title: "Delete Chat?",
                                                middleText:
                                                    "Are you sure you want to delete '$chatTitle'?",
                                                textConfirm: "Delete",
                                                textCancel: "Cancel",
                                                confirmTextColor: Colors.white,
                                                buttonColor: Colors.blue,
                                                onConfirm: () {
                                                  c.deleteChatSession(index);
                                                  Navigator.pop(context);
                                                },
                                                onCancel: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                              break;
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                value: 'share',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.share,
                                                      color: Colors.white,
                                                      size: 18.w,
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      'Share',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'rename',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                      size: 18.w,
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      'Rename',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'pin',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.push_pin,
                                                      color: Colors.white,
                                                      size: 18.w,
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      'Pin',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 18.w,
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                        color: Colors.grey.shade800,
                                      ),
                                    );
                                  }),
                                );
                              }),
                            ],
                          ),
                        ),

                        _sidebarItem(context, Icons.search, "Search", () {
                          Navigator.of(context).pop();
                        }),
                        _sidebarItem(
                          context,
                          Icons.calendar_today,
                          "Calendar",
                          () {},
                        ),
                        _sidebarItem(
                          context,
                          Icons.timeline,
                          "Activity",
                          () {},
                        ),
                        _sidebarItem(context, Icons.menu, "Menu", () {}),
                        _sidebarItem(context, Icons.book, "Book", () {}),

                        SizedBox(height: 16.h),

                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                          child: Text(
                            "CHAT",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        _sidebarItem(
                          context,
                          Icons.chat_bubble_outline,
                          "Chatboard",
                          () {},
                        ),
                        _sidebarItem(
                          context,
                          Icons.forum_outlined,
                          "Session",
                          () {},
                        ),
                        _sidebarItem(context, Icons.dashboard, "Dashboard", () {
                          Navigator.of(context).pop();
                          Get.to(() => const DashboardScreen());
                        }),

                        _sidebarItem(
                          context,
                          Icons.delete_forever,
                          "Clear All Chats",
                          () {
                            c.clearChatHistory();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Handle logout
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sidebarItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isSelected = false,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.3),
      trailing: trailing,
    );
  }
}
