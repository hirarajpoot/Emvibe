import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Controllers/GeneralSettingsController.dart';
import '../GeneralSettings/widgets/LanguageSelectionPage.dart';

import 'widgets/theme_selection_dialog.dart';
import 'widgets/background_selection_dialog.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<GeneralSettingsController>();

    return Obx(() {
      final isDarkMode = settingsController.isDarkMode.value;
      final backgroundColor = isDarkMode ? Colors.black : Colors.grey.shade100;
      final textColor = isDarkMode ? Colors.white : Colors.black;
      final cardColor = isDarkMode ? Colors.grey.shade900 : Colors.white;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          title: Text(
            "general_settings".tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor, size: 24.w),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.language,
                title: "set_language".tr,
                onTap: () {
                  Get.to(() => LanguageSelectionPage());
                },
                cardColor: cardColor,
                textColor: textColor,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.palette,
                title: "set_theme".tr,
                onTap: () {
                  // 🔥 Fixed: Use Get.dialog to show the dialog over the current screen
                  Get.dialog(ThemeSelectionDialog());
                },
                cardColor: cardColor,
                textColor: textColor,
              ),
              // NEW: Replaced with a switch-based tile
              _buildSwitchSettingsTile(
                context,
                icon: Icons.notifications_none,
                title: "set_notifications".tr,
                value: settingsController.notificationsEnabled.value,
                onChanged: (value) => settingsController.toggleNotifications(value),
                cardColor: cardColor,
                textColor: textColor,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.photo_size_select_actual_outlined,
                title: "set_background".tr,
                onTap: () {
                  // 🔥 Fixed: Use Get.dialog to show the dialog over the current screen
                  Get.dialog(BackgroundSelectionDialog());
                },
                cardColor: cardColor,
                textColor: textColor,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSettingsTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      required Color cardColor,
      required Color textColor}) {
    return Card(
      color: cardColor,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        leading: Icon(icon, color: textColor, size: 22.w),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, color: textColor),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: textColor.withOpacity(0.5),
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  // NEW: A separate widget for a tile with a switch
  Widget _buildSwitchSettingsTile(BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color cardColor,
    required Color textColor,
  }) {
    return Card(
      color: cardColor,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        leading: Icon(icon, color: textColor, size: 22.w),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, color: textColor),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue.shade700,
        ),
        onTap: () => onChanged(!value),
      ),
    );
  }
}