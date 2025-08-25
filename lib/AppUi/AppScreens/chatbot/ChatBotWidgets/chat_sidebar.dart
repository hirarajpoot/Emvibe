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
                                icon: const Icon(Icons.close, color: Colors.white70),
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
                            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                          ),
                        ),
                        _sidebarItem(context, Icons.chat_bubble_outline, "Chatbot", () {
                          Navigator.of(context).pop();
                          Get.to(() => const ChatBotPage());
                        }),

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
                            title: Text("Recent Chats", style: const TextStyle(color: Colors.white)),
                            childrenPadding: EdgeInsets.only(left: 20.w), 
                            children: [
                              Obx(() { 
                                final sortedChatSessions = c.getSortedChatSessions(); 
                                if (sortedChatSessions.isEmpty) {
                                  return _sidebarItem(context, Icons.info_outline, "No Recent Chats", () {
                                    
                                  });
                                }
                                return Column(
                                  children: List.generate(sortedChatSessions.length, (index) {
                                    final chatSession = sortedChatSessions[index]; 
                                    
                                    final isSelected = c.currentChatSessionIndex.value != -1 &&
                                                       c.chatHistory.isNotEmpty && 
                                                       c.currentChatSessionIndex.value < c.chatHistory.length &&
                                                       c.chatHistory[c.currentChatSessionIndex.value] == chatSession;
                                    
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
                                      trailing: PopupMenuButton<String>(
                                        icon: Icon(Icons.more_vert, color: Colors.white70, size: 20.w),
                                        onSelected: (String result) {
                                          switch (result) {
                                            case 'share':
                                              c.shareChatSession(chatSession); 
                                              break;
                                            case 'rename':
                                              final TextEditingController renameController = TextEditingController(text: chatSession.customTitle.value);
                                              Get.defaultDialog(
                                                backgroundColor: Colors.grey.shade800,
                                                title: "Rename Chat",
                                                titleStyle: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller: renameController,
                                                      autofocus: true,
                                                      cursorColor: Colors.white,
                                                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                                      decoration: InputDecoration(
                                                        hintText: "Enter new chat name",
                                                        hintStyle: TextStyle(color: Colors.white54),
                                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                textConfirm: "Rename",
                                                textCancel: "Cancel",
                                                confirmTextColor: Colors.white,
                                                buttonColor: Colors.blue,
                                                cancelTextColor: Colors.white,
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
                                                backgroundColor: Colors.grey.shade800, 
                                                title: "Delete Chat?",
                                                titleStyle: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                                                middleText: "Are you sure you want to delete '${chatSession.customTitle.value}'?",
                                                middleTextStyle: TextStyle(color: Colors.white70, fontSize: 14.sp),
                                                textConfirm: "Delete",
                                                textCancel: "Cancel",
                                                confirmTextColor: Colors.white,
                                                buttonColor: Colors.blue, 
                                                cancelTextColor: Colors.white, 
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
                                                Icon(Icons.share, color: Colors.white, size: 18.w),
                                                SizedBox(width: 8.w),
                                                Text('Share', style: TextStyle(color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'pin_unpin',
                                            child: Obx(() => Row( 
                                              children: [
                                                Icon(
                                                  chatSession.isPinned.value ? Icons.push_pin_outlined : Icons.push_pin,
                                                  color: Colors.white,
                                                  size: 18.w,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  chatSession.isPinned.value ? 'Unpin Chat' : 'Pin Chat',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            )),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'rename',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit, color: Colors.white, size: 18.w),
                                                SizedBox(width: 8.w),
                                                Text('Rename', style: TextStyle(color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete, color: Colors.white, size: 18.w),
                                                SizedBox(width: 8.w),
                                                Text('Delete', style: TextStyle(color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ],
                                        color: Colors.grey.shade800, 
                                      ),
                                    ));
                                  }),
                                );
                              }),
                            ],
                          ),
                        ),
                        
                        _sidebarItem(context, Icons.search, "Search", () { Navigator.of(context).pop(); }),
                        _sidebarItem(context, Icons.calendar_today, "Calendar", () {}),
                        _sidebarItem(context, Icons.timeline, "Activity", () {}),
                        _sidebarItem(context, Icons.menu, "Menu", () {}),
                        _sidebarItem(context, Icons.book, "Book", () {}),

                        SizedBox(height: 16.h),

                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                          child: Text("CHAT", style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                        ),
                        _sidebarItem(context, Icons.chat_bubble_outline, "Chatboard", () {}),
                        _sidebarItem(context, Icons.forum_outlined, "Session", () {}),
                        _sidebarItem(context, Icons.dashboard, "Dashboard", () {
                          Navigator.of(context).pop();
                          Get.to(() => const DashboardScreen());
                        }),

                        _sidebarItem(context, Icons.delete_forever, "Clear All Chats", () {
                          Get.defaultDialog(
                            backgroundColor: Colors.grey.shade800, 
                            title: "Clear All Chats?",
                            titleStyle: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                            middleText: "Are you sure you want to clear all chat history? Pinned chats will not be deleted.",
                            middleTextStyle: TextStyle(color: Colors.white70, fontSize: 14.sp),
                            textConfirm: "Clear All", 
                            textCancel: "Cancel", 
                            confirmTextColor: Colors.white, 
                            buttonColor: Colors.blue, 
                            cancelTextColor: Colors.white, 
                            onConfirm: () {
                              c.clearChatHistory(); 
                              Navigator.pop(context); 
                            },
                            onCancel: () {
                              Navigator.pop(context); 
                            },
                          );
                        }),
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
