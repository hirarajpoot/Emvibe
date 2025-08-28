import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'Reminder/create_reminder_page.dart';
// import 'Reminder/get_reminders_page.dart';
import 'Reminder/GetRemindersPage.dart';
import 'Reminder/delete_reminder_page.dart';
import '../../../Controllers/Reminder/reminder_controller.dart'; // ✅ Controller ko import kiya

class ProductivityToolsPage extends StatelessWidget {
  const ProductivityToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Controller ko yahan initialize karein taake woh har jagah available ho
    Get.put(ReminderController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Productivity / Tools".tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Reminder Tools Section ---
            _buildSectionHeader("Reminders".tr, context),
            _buildToolsGrid(
              context,
              [
                _buildToolCard(Icons.alarm_add, "Create Reminder", context, () {
                  Get.to(() => const CreateReminderPage());
                }),
                _buildToolCard(Icons.list_alt, "Get Reminders", context, () {
                  Get.to(() => const GetRemindersPage());
                }),
                _buildToolCard(Icons.alarm_off, "Delete Reminder", context, () {
                  Get.to(() => const DeleteReminderPage());
                }),
              ],
            ),
            SizedBox(height: 20.h),

            // --- Notes Tools Section ---
            _buildSectionHeader("Notes".tr, context),
            _buildToolsGrid(
              context,
              [
                _buildToolCard(Icons.note_add, "Create Note", context, () {
                  Get.snackbar("Coming Soon", "Create Note feature is not yet implemented.");
                }),
                _buildToolCard(Icons.notes, "Get Notes", context, () {
                  Get.snackbar("Coming Soon", "Get Notes feature is not yet implemented.");
                }),
                _buildToolCard(Icons.note_alt_outlined, "Delete Note", context, () {
                  Get.snackbar("Coming Soon", "Delete Note feature is not yet implemented.");
                }),
              ],
            ),
            SizedBox(height: 20.h),

            // --- To-Do List Section ---
            _buildSectionHeader("To-Do List".tr, context),
            _buildToolsGrid(
              context,
              [
                _buildToolCard(Icons.playlist_add, "Add To-Do", context, () {
                  Get.snackbar("Coming Soon", "Add To-Do feature is not yet implemented.");
                }),
                _buildToolCard(Icons.format_list_bulleted, "Get To-Do List", context, () {
                  Get.snackbar("Coming Soon", "Get To-Do List feature is not yet implemented.");
                }),
                _buildToolCard(Icons.check_box, "Update To-Do", context, () {
                  Get.snackbar("Coming Soon", "Update To-Do feature is not yet implemented.");
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    // ... (rest of the code is the same)
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildToolsGrid(BuildContext context, List<Widget> children) {
    // ... (rest of the code is the same)
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.8,
      mainAxisSpacing: 10.w,
      crossAxisSpacing: 10.h,
      children: children,
    );
  }

  Widget _buildToolCard(IconData icon, String title, BuildContext context, VoidCallback onTap) {
    // ... (rest of the code is the same)
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.w, color: Theme.of(context).primaryColor),
            SizedBox(height: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}