// lib/AppUi/AppScreens/general_settings/LanguageSelectionPage.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Controllers/GeneralSettingsController.dart';

class LanguageSelectionPage extends StatelessWidget {
  LanguageSelectionPage({super.key});

  final List<Map<String, String>> languages = [
    {"code": "en", "name": "English"},
    {"code": "ur", "name": "اردو"},
    {"code": "hi", "name": "हिन्दी"},
    {"code": "ar", "name": "العربية"},
    {"code": "fr", "name": "Français"},
    {"code": "es", "name": "Español"},
    {"code": "de", "name": "Deutsch"},
    {"code": "zh", "name": "中文"},
  ];

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<GeneralSettingsController>();

    return Obx(() {
      final isDarkMode = settingsController.isDarkMode.value;
      final backgroundColor = isDarkMode ? Colors.black : Colors.white;
      final textColor = isDarkMode ? Colors.white : Colors.black;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
            "select_language".tr,
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
        body: ListView.builder(
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final lang = languages[index];
            return Obx(() {
              final selectedLang = settingsController.selectedLanguage.value;
              final isSelected = selectedLang == lang["code"];

              return Card(
                color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    color: isSelected ? Colors.blue.shade700 : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    lang["name"]!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: textColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: Colors.blue.shade700)
                      : null,
                  onTap: () {
                    settingsController.setLanguage(lang["code"]!);
                    Get.back();
                  },
                ),
              );
            });
          },
        ),
      );
    });
  }
}
