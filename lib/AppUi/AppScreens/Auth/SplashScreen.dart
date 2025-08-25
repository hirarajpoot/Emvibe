import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async'; 

import 'LoginScreen.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Get.offAll(() => const LoginScreen());
    });
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
