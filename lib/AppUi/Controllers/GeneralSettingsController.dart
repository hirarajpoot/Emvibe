import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GeneralSettingsController extends GetxController {
  final box = GetStorage();

  final themeMode = ThemeMode.system.obs;
  final isDarkMode = false.obs;
  final selectedLanguage = 'en'.obs;
  final currentLocale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
    _loadLanguage();
  }

  void _loadThemeMode() {
    final savedTheme = box.read('theme');
    if (savedTheme == 'light') {
      themeMode.value = ThemeMode.light;
      isDarkMode.value = false;
    } else if (savedTheme == 'dark') {
      themeMode.value = ThemeMode.dark;
      isDarkMode.value = true;
    } else {
      final isSystemDark = Get.isPlatformDarkMode;
      themeMode.value = ThemeMode.system;
      isDarkMode.value = isSystemDark;
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    box.write('theme', mode.toString().split('.').last);

    if (mode == ThemeMode.system) {
      isDarkMode.value = Get.isPlatformDarkMode;
    } else {
      isDarkMode.value = mode == ThemeMode.dark;
    }

    Get.changeThemeMode(mode);
  }

  void _loadLanguage() {
    final savedLang = box.read('language') ?? 'en';
    selectedLanguage.value = savedLang.toString();
    currentLocale.value = Locale(savedLang);
    Get.updateLocale(Locale(savedLang));
  }

  void setLanguage(String code) {
    selectedLanguage.value = code;
    currentLocale.value = Locale(code);
    box.write('language', code);
    Get.updateLocale(Locale(code));
  }
}