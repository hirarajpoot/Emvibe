// lib/AppUi/AppScreens/general_settings/GeneralSettingsPage.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Controllers/GeneralSettingsController.dart';
import '../general_settings/LanguageSelectionPage.dart';

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
                  _showThemeSelectionDialog(context);
                },
                cardColor: cardColor,
                textColor: textColor,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.notifications_none,
                title: "set_notifications".tr,
                onTap: () {
                  _showSnackbar(context, "coming_soon".tr);
                },
                cardColor: cardColor,
                textColor: textColor,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.photo_size_select_actual_outlined,
                title: "set_background".tr,
                onTap: () {
                  _showSnackbar(context, "coming_soon".tr);
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

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10.w),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    final settingsController = Get.find<GeneralSettingsController>();
    Get.dialog(
      AlertDialog(
        backgroundColor:
            settingsController.isDarkMode.value ? Colors.grey.shade800 : Colors.white,
        title: Text(
          "select_theme".tr,
          style: TextStyle(
            color: settingsController.isDarkMode.value ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(context, "system".tr, ThemeMode.system),
            _buildThemeOption(context, "light".tr, ThemeMode.light),
            _buildThemeOption(context, "dark".tr, ThemeMode.dark),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String title, ThemeMode mode) {
    final settingsController = Get.find<GeneralSettingsController>();
    return Obx(() => ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: settingsController.themeMode == mode
                  ? settingsController.isDarkMode.value
                      ? Colors.white
                      : Colors.blue.shade700
                  : settingsController.isDarkMode.value
                      ? Colors.white70
                      : Colors.black54,
              fontWeight: settingsController.themeMode == mode
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          trailing: settingsController.themeMode == mode
              ? Icon(Icons.check_circle, color: Colors.blue.shade700)
              : null,
          onTap: () {
            settingsController.setThemeMode(mode);
            Get.back();
          },
        ));
  }
}
