import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/GeneralSettingsController.dart';

class ThemeSelectionDialog extends StatelessWidget {
  const ThemeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<GeneralSettingsController>();
    return AlertDialog(
      backgroundColor: settingsController.isDarkMode.value ? Colors.grey.shade800 : Colors.white,
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