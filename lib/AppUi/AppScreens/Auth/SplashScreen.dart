import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async'; 
import 'package:get_storage/get_storage.dart';

import 'LoginScreen.dart';
import '../chatbot/chatbot_page.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    // Simulate app initialization
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if user is already logged in (for demo purposes, we'll skip to chatbot)
    // In a real app, you would check Firebase Auth or stored tokens
    final box = GetStorage();
    final isLoggedIn = box.read('isLoggedIn') ?? false;
    
    if (isLoggedIn) {
      Get.offAll(() => const ChatBotPage());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Color(0xFF1A237E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Emvibe", 
              style: TextStyle(
                color: Colors.white,
                fontSize: 48.sp, 
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0, 
              ),
            ),
            SizedBox(height: 20.h),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
