import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'LoginScreen.dart'; // Reset ke baad LoginScreen par wapas bhejenge

// ResetPasswordScreen ke liye ek GetX Controller
class ResetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final RxString emailError = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // 🔥 Validation function
  bool _validateInputs() {
    emailError.value = '';
    bool isValid = true;
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required.';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Enter a valid email address.';
      isValid = false;
    }
    return isValid;
  }

  // Password Reset Email Send Karein
  Future<void> sendPasswordResetEmail() async {
    if (!_validateInputs()) {
      return;
    }

    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      Get.snackbar(
        "Success",
        "Password reset link sent to your email. Please check your inbox.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      // 🔥 Email send hone ke baad LoginScreen par wapas bhej dein
      Get.offAll(() => const LoginScreen()); 
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Failed to send reset email. Please try again.";
      if (e.code == 'user-not-found') {
        emailError.value = "No user found for this email.";
        errorMessage = ""; // Snackbar se bachen agar inline error dikhana hai
      } else if (e.code == 'invalid-email') {
        emailError.value = "The email address is not valid.";
        errorMessage = "";
      }

      if (errorMessage.isNotEmpty) {
         Get.snackbar(
          "Error",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController resetController = Get.put(ResetPasswordController());

    return Scaffold(
      backgroundColor: Color(0xFFF0F4F8), // Light grey background
      appBar: AppBar(
        backgroundColor: Color(0xFFF0F4F8), // AppBar ka background bhi light grey
        elevation: 0,
        leading: IconButton( // Back button
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          onPressed: () => Get.back(), // Pichli screen par wapas jane ke liye
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50.h),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Emvibe",
                  style: TextStyle(
                    color: Color(0xFF1A237E),
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 50.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your email to receive a password reset link.",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Email Input with custom box decoration and inline error
              Obx(() => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: resetController.emailError.value.isNotEmpty
                        ? Colors.red
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: resetController.emailController,
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => resetController.emailError.value = '',
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email, color: Colors.grey.shade500),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                    border: InputBorder.none,
                    errorText: resetController.emailError.value.isEmpty
                        ? null
                        : resetController.emailError.value,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
              )),
              SizedBox(height: 30.h),

              Obx(() => ElevatedButton(
                onPressed: resetController.isLoading.value ? null : () => resetController.sendPasswordResetEmail(),
                child: resetController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Send Reset Link",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
              )),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
