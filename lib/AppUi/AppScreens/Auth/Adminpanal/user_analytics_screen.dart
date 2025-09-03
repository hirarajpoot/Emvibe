import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controllers/Adminpanal/user_analytics_controller.dart';

class UserAnalyticsScreen extends StatelessWidget {
  const UserAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserAnalyticsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          "User Analytics",
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // 🔹 Analytics Summary Cards
            _buildSummaryRow(controller),
            SizedBox(height: 20.h),
            
            // 🔹 User Demographics Chart (Placeholder)
            _buildChartCard(
              title: "Users by Role",
              child: const Text(
                "Chart will be displayed here.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 20.h),

            // 🔹 User List (Placeholder)
            _buildListCard(
              title: "Recent Users",
              child: const ListTile(
                title: Text("User Name"),
                subtitle: Text("user@example.com"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(UserAnalyticsController controller) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: "Total Users",
              value: "${controller.totalUsers.value}",
              icon: Icons.group,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildSummaryCard(
              title: "New Users",
              value: "+${controller.newUsersThisWeek.value}",
              icon: Icons.person_add,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildSummaryCard(
              title: "Active Users",
              value: "${controller.activeUsers.value}",
              icon: Icons.person_pin_circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        child: Column(
          children: [
            Icon(icon, size: 30.w, color: const Color(0xFF1A237E)),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A237E),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A237E),
              ),
            ),
            SizedBox(height: 16.h),
            Center(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A237E),
              ),
            ),
            SizedBox(height: 10.h),
            child,
          ],
        ),
      ),
    );
  }
}