import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatSidebar extends StatelessWidget {
  const ChatSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: SafeArea(
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
                        style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(Icons.close, color: Colors.white70),
                  ],
                ),
              ),
              Divider(color: Colors.white24, height: 1.h),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: Text("MAIN", style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
              ),
              _sidebarItem(context, Icons.dashboard, "Dashboard"),
              _sidebarItem(context, Icons.calendar_today, "Calendar"),
              _sidebarItem(context, Icons.timeline, "Activity"),
              _sidebarItem(context, Icons.menu, "Menu"),
              _sidebarItem(context, Icons.book, "Book"),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                child: Text("CHAT", style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
              ),
              _sidebarItem(context, Icons.chat_bubble_outline, "Chatboard"),
              _sidebarItem(context, Icons.forum_outlined, "Session"),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text("Logout", style: TextStyle(color: Colors.white)),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sidebarItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () => Navigator.of(context).pop(),
    );
  }
}
