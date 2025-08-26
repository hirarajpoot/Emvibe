// lib/AppUi/Controllers/GeneralSettingsController.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GeneralSettingsController extends GetxController {
  // GetStorage ka instance banana taake data save ho sake.
  final box = GetStorage();
  
  // ThemeMode ko observe karne ke liye Rx (Reactive variable)
  late Rx<ThemeMode> _themeMode;
  
  // IsDarkMode ko observe karne ke liye RxBool
  late RxBool _isDarkMode;

  @override
  void onInit() {
    super.onInit();
    // App start hone par saved theme mode load karna.
    _loadThemeMode();
  }

  // Theme mode ko load karne ka function
  void _loadThemeMode() {
    final savedTheme = box.read('theme');
    if (savedTheme == 'light') {
      _themeMode = ThemeMode.light.obs;
      _isDarkMode = false.obs;
    } else if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark.obs;
      _isDarkMode = true.obs;
    } else {
      // Jab theme save na ho, toh system theme ko use karna
      final isSystemDark = Get.isPlatformDarkMode;
      _themeMode = ThemeMode.system.obs;
      _isDarkMode = isSystemDark.obs;
    }
  }

  // Theme mode ko change karne aur save karne ka function
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    
    // GetStorage mein theme mode ko save karna
    box.write('theme', mode.toString().split('.').last);

    // IsDarkMode ko update karna
    if (mode == ThemeMode.system) {
      _isDarkMode.value = Get.isPlatformDarkMode;
    } else {
      _isDarkMode.value = mode == ThemeMode.dark;
    }
    
    // App ka theme change karna
    Get.changeThemeMode(mode);
  }

  // Current theme mode ko access karne ke liye getter
  ThemeMode get themeMode => _themeMode.value;
  RxBool get isDarkMode => _isDarkMode;
}
