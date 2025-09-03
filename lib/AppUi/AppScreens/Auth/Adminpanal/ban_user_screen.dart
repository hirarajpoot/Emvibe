import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controllers/Adminpanal/ban_user_controller.dart';

class BanUserScreen extends StatelessWidget {
  const BanUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BanUserController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          "Ban User",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // 🔹 Search Bar
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Search user by email...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: const BorderSide(color: Color(0xFF1A237E), width: 1.5),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // 🔹 Search Results List
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (controller.searchResults.isEmpty &&
                    controller.searchController.text.isNotEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "No users found.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final user = controller.searchResults[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: ListTile(
                          title: Text(user['email'], style: TextStyle(fontSize: 16.sp)),
                          trailing: ElevatedButton(
                            onPressed: () => controller.toggleUserBanStatus(
                              user['id'],
                              user['isBanned'],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: user['isBanned']
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              user['isBanned'] ? "Unban" : "Ban",
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}