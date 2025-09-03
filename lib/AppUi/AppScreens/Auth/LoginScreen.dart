import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'SignupScreen.dart';
import '../chatbot/chatbot_page.dart';
import 'Adminpanal/admin_panel_screen.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final RxBool _isPasswordVisible = false.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  bool get isPasswordVisible => _isPasswordVisible.value;
  void togglePasswordVisibility() =>
      _isPasswordVisible.value = !_isPasswordVisible.value;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  bool _validateInputs() {
    emailError.value = '';
    passwordError.value = '';
    bool isValid = true;

    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required.';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Enter a valid email address.';
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required.';
      isValid = false;
    }
    return isValid;
  }

  Future<void> loginWithEmailAndPassword() async {
    if (!_validateInputs()) return;

    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // 🔹 Step 1: Fixed Admin Check
      if (email == "admin@gmail.com" && password == "123456") {
        Get.offAll(() => const AdminPanelScreen());
        return;
      }

      // 🔹 Step 2: Normal User Firebase Login
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Firestore se role check
        final doc = await _firestore.collection('users').doc(user.uid).get();
        final role = doc.data()?['role'] ?? 'user';

        if (role == 'admin') {
          Get.offAll(() => const AdminPanelScreen());
        } else {
          Get.offAll(() => const ChatBotPage());
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emailError.value = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        passwordError.value = "Wrong password provided.";
      } else {
        Get.snackbar(
          "Error",
          "Login failed: ${e.message}",
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
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
                    color: const Color(0xFF1A237E),
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
                  "Login to your Account",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Email Field
              Obx(
                () => TextField(
                  controller: loginController.emailController,
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => loginController.emailError.value = '',
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(Icons.email, color: Colors.grey.shade500),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 16.w,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: loginController.emailError.value.isNotEmpty
                            ? Colors.red
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    errorText: loginController.emailError.value.isEmpty
                        ? null
                        : loginController.emailError.value,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Password Field
              Obx(
                () => TextField(
                  controller: loginController.passwordController,
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  obscureText: !loginController.isPasswordVisible,
                  onChanged: (value) =>
                      loginController.passwordError.value = '',
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey.shade500),
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginController.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: loginController.togglePasswordVisibility,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 16.w,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: loginController.passwordError.value.isNotEmpty
                            ? Colors.red
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    errorText: loginController.passwordError.value.isEmpty
                        ? null
                        : loginController.passwordError.value,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Login Button
              Obx(
                () => ElevatedButton(
                  onPressed: loginController.isLoading.value
                      ? null
                      : () => loginController.loginWithEmailAndPassword(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    textStyle: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 0,
                    minimumSize: Size(double.infinity, 52.h),
                  ),
                  child: loginController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ),
              SizedBox(height: 30.h),

              TextButton(
                onPressed: () {
                  Get.offAll(() => const SignupScreen());
                },
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign up here",
                        style: TextStyle(
                          color: const Color(0xFF1A237E),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
