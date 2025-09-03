import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controllers/Adminpanal/manage_server_load_controller.dart';

class ManageServerLoadScreen extends StatelessWidget {
  const ManageServerLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ManageServerLoadController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          "Manage Server Load",
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
            SizedBox(height: 20.h),
            _buildMetricCard(
              title: "CPU Usage",
              value: controller.cpuUsage,
              icon: Icons.speed,
              color: Colors.red.shade400,
            ),
            _buildMetricCard(
              title: "RAM Usage",
              value: controller.ramUsage,
              icon: Icons.memory,
              color: Colors.blue.shade400,
            ),
            _buildMetricCard(
              title: "API Call Rate",
              value: controller.apiCallRate,
              icon: Icons.cloud_upload,
              color: Colors.green.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required RxDouble value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Icon(icon, size: 40.w, color: color),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Obx(
                    () => Text(
                      "${value.value.toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}