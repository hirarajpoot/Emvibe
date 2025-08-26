// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Controllers ko import kiya gaya hai
import 'AppUi/Controllers/chatbot_controller.dart';
import 'AppUi/Controllers/GeneralSettingsController.dart';

// App screens ko import kiya gaya hai
import 'AppUi/AppScreens/Auth/SplashScreen.dart';

import 'firebase_options.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // GetStorage ko initialize kiya gaya hai
  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Zaroori controllers ko initialize kiya gaya hai
  Get.put(ChatBotController()); 
  Get.put(GeneralSettingsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp ke liye GeneralSettingsController se theme ko retrieve karna
    final settingsController = Get.find<GeneralSettingsController>();

    return ScreenUtilInit(
      designSize: const Size(360, 800), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Emvibe Chatbot',
          
          themeMode: settingsController.themeMode,
          
          // Light theme
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: const Color(0xFFF0F4F8), 
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.black, fontSize: 16.sp),
              bodyMedium: TextStyle(color: Colors.black87, fontSize: 14.sp),
              titleLarge: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
              titleMedium: TextStyle(color: Colors.black, fontSize: 18.sp),
            ),
            inputDecorationTheme: InputDecorationTheme( 
              labelStyle: TextStyle(color: Colors.grey.shade600),
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIconColor: Colors.grey.shade500,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.transparent), 
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2), 
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              filled: true,
              fillColor: Colors.white, 
              errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData( 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E), 
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                elevation: 0,
                minimumSize: Size(double.infinity, 52.h), 
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1A237E),
                textStyle: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          
          // Dark theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white, fontSize: 16.sp),
              bodyMedium: TextStyle(color: Colors.white70, fontSize: 14.sp),
              titleLarge: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
              titleMedium: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
            inputDecorationTheme: InputDecorationTheme( 
              labelStyle: TextStyle(color: Colors.grey.shade300),
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIconColor: Colors.grey.shade400,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFF9FA8DA), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade900,
              errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData( 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9FA8DA), 
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                elevation: 0,
                minimumSize: Size(double.infinity, 52.h),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF9FA8DA),
                textStyle: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          
          home: const SplashScreen(), 
        );
      },
    );
  }
}
