import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controllers/Adminpanal/admin_panel_controller.dart';
import 'user_analytics_screen.dart';
import 'ban_user_screen.dart';
import 'update_knowledge_base_screen.dart';
import 'manage_server_load_screen.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminPanelController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              _buildFeatureCard(
                context,
                icon: Icons.analytics,
                title: "User Analytics",
                subtitle: "View user data and app usage.",
                onTap: () {
                  Get.to(() => const UserAnalyticsScreen());
                },
              ),
              _buildFeatureCard(
                context,
                icon: Icons.person_off,
                title: "Ban User",
                subtitle: "Block or unblock users from the app.",
                onTap: () {
                  Get.to(() => const BanUserScreen());
                },
              ),
              _buildFeatureCard(
                context,
                icon: Icons.update,
                title: "Update Knowledge Base",
                subtitle: "Edit and manage the app's knowledge base.",
                onTap: () {
                  Get.to(() => const UpdateKnowledgeBaseScreen());
                },
              ),
              _buildFeatureCard(
                context,
                icon: Icons.dns,
                title: "Manage Server Load",
                subtitle: "Monitor and manage server resources.",
                onTap: () {
                  Get.to(() => const ManageServerLoadScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 20.w,
        ),
        leading: Icon(
          icon,
          size: 30.w,
          color: const Color(0xFF1A237E),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A237E),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}