import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // 🔥 FontAwesomeIcons import zaroori hai
// 🔥 TapGestureRecognizer ka import hata diya gaya hai, kyunki ab text ke bajaye button hai

import 'SignupScreen.dart';
import 'ResetPasswordScreen.dart';
import '../chatbot/chatbot_page.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final RxBool _isPasswordVisible = false.obs;

  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool get isPasswordVisible => _isPasswordVisible.value;
  void togglePasswordVisibility() =>
      _isPasswordVisible.value = !_isPasswordVisible.value;

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
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters.';
      isValid = false;
    }
    return isValid;
  }

  Future<void> loginUser() async {
    if (!_validateInputs()) {
      return;
    }

    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.snackbar(
        "Success",
        "Logged in successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      Get.offAll(() => const ChatBotPage());
    } on FirebaseAuthException catch (e) {
      String genericErrorMessage = "Login failed. Please try again.";
      if (e.code == 'user-not-found') {
        emailError.value = "No user found for this email.";
        genericErrorMessage = "";
      } else if (e.code == 'wrong-password') {
        passwordError.value = "Incorrect password.";
        genericErrorMessage = "";
      } else if (e.code == 'invalid-email') {
        emailError.value = "The email address is not valid.";
        genericErrorMessage = "";
      } else if (e.code == 'channel-error') {
        genericErrorMessage = "Login failed. Please check your setup.";
      }

      if (genericErrorMessage.isNotEmpty) {
        Get.snackbar(
          "Error",
          genericErrorMessage,
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

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Get.snackbar(
        "Success",
        "Logged in with Google successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      Get.offAll(() => const ChatBotPage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        "Google sign-in failed: ${e.message}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred during Google sign-in: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithFacebook() {
    Get.snackbar(
      "Feature Coming Soon",
      "Facebook authentication will be available soon!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void signInWithX() {
    Get.snackbar(
      "Feature Coming Soon",
      "X (Twitter) authentication will be available soon!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Color(0xFFF0F4F8),
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
                  "Login to your Account",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Email Input with custom box decoration and inline error
              Obx(
                () => Container(
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
                      color: loginController.emailError.value.isNotEmpty
                          ? Colors.red
                          : Colors.transparent, // Default no border
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: loginController.emailController,
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => loginController.emailError.value = '',
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey.shade500,
                      ), // 🔥 Email Icon
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 16.w,
                      ),
                      border: InputBorder.none,
                      errorText: loginController.emailError.value.isEmpty
                          ? null
                          : loginController.emailError.value,
                      errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Password Input with custom box decoration, inline error, and toggle
              Obx(
                () => Container(
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
                      color: loginController.passwordError.value.isNotEmpty
                          ? Colors.red
                          : Colors.transparent, // Default no border
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: loginController.passwordController,
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    obscureText: !loginController
                        .isPasswordVisible, // 🔥 Toggle visibility
                    onChanged: (value) =>
                        loginController.passwordError.value = '',
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey.shade500,
                      ), // 🔥 Password Icon
                      suffixIcon: IconButton(
                        // 🔥 Show/Hide Password Icon
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
                      border: InputBorder.none,
                      errorText: loginController.passwordError.value.isEmpty
                          ? null
                          : loginController.passwordError.value,
                      errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const ResetPasswordScreen());
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Color(0xFF1A237E), fontSize: 14.sp),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Obx(
                () => ElevatedButton(
                  onPressed: loginController.isLoading.value
                      ? null
                      : () => loginController.loginUser(),
                  child: loginController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 30.h),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      "Or sign in with",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(
                    onPressed: loginController.isLoading.value
                        ? null
                        : () => loginController.signInWithGoogle(),
                    icon: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png",
                      height: 24.w,
                      width: 24.w,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.g_mobiledata,
                        size: 30.w,
                        color: Colors.red,
                      ),
                    ),
                    heroTag: "googleLogin",
                  ),
                  SizedBox(width: 20.w),

                  _buildSocialButton(
                    onPressed: loginController.isLoading.value
                        ? null
                        : () => loginController.signInWithFacebook(),
                    icon: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.blue.shade800,
                      size: 24.w,
                    ),
                    heroTag: "facebookLogin",
                  ),
                  SizedBox(width: 20.w),

                  _buildSocialButton(
                    onPressed: loginController.isLoading.value
                        ? null
                        : () => loginController.signInWithX(),
                    icon: Icon(
                      FontAwesomeIcons.xTwitter,
                      color: Colors.black,
                      size: 24.w,
                    ),
                    heroTag: "xLogin",
                  ),
                ],
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
                        text: "Sign Up",
                        style: TextStyle(
                          color: Color(0xFF1A237E),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 _buildSocialButton helper widget yahan dobara add kiya gaya hai
  Widget _buildSocialButton({
    VoidCallback? onPressed,
    required Widget icon,
    required String heroTag,
  }) {
    return SizedBox(
      width: 55.w,
      height: 55.w,
      child: FloatingActionButton(
        onPressed: onPressed,
        heroTag: heroTag,
        backgroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: icon,
      ),
    );
  }
}
