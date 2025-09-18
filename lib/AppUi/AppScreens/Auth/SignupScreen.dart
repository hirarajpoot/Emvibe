import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'LoginScreen.dart';
import '../chatbot/chatbot_page.dart';
import 'Adminpanal/admin_panel_screen.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  final RxBool _isPasswordVisible = false.obs;
  final RxBool _isConfirmPasswordVisible = false.obs;

  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool get isPasswordVisible => _isPasswordVisible.value;
  void togglePasswordVisibility() =>
      _isPasswordVisible.value = !_isPasswordVisible.value;

  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      _isConfirmPasswordVisible.value = !_isConfirmPasswordVisible.value;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  bool _validateInputs() {
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';

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

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required.';
      isValid = false;
    } else if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match.';
      isValid = false;
    }
    return isValid;
  }

  Future<void> signUpWithEmailAndPassword() async {
    if (!_validateInputs()) {
      return;
    }

    isLoading.value = true;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // ✅ Loading stop
        isLoading.value = false;

        // ✅ Signup ke baad LoginScreen pe bhejo
        Get.offAll(() => const LoginScreen());

        Get.snackbar(
          "Success",
          "Account created successfully. Please login.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false; // ❌ error pe bhi band karo

      String genericErrorMessage = "Sign Up failed. Please try again.";
      if (e.code == 'weak-password') {
        passwordError.value = "Password is too weak.";
        genericErrorMessage = "";
      } else if (e.code == 'email-already-in-use') {
        emailError.value = "This email is already in use.";
        genericErrorMessage = "";
      } else if (e.code == 'invalid-email') {
        emailError.value = "The email address is not valid.";
        genericErrorMessage = "";
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
      isLoading.value = false; // ❌ catch me bhi
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
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

      // Guard against null tokens
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;
      if (accessToken == null || idToken == null) {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "Google sign-in failed: Missing authentication tokens",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!doc.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'email': user.email,
            'role': 'user',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        isLoading.value = false;

        if (user.email == "admin@gmail.com") {
          Get.offAll(() => const AdminPanelScreen());
        } else {
          Get.offAll(() => const ChatBotPage());
        }
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Google sign-in failed: ${e.message}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "An unexpected error occurred during Google sign-in: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
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

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.put(SignupController());

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
                  "Create your Account",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Email Input
              Obx(
                () => TextField(
                  controller: signupController.emailController,
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => signupController.emailError.value = '',
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey.shade500,
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
                        color: signupController.emailError.value.isNotEmpty
                            ? Colors.red
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    errorText: signupController.emailError.value.isEmpty
                        ? null
                        : signupController.emailError.value,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Password Input
              Obx(
                () => TextField(
                  controller: signupController.passwordController,
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  obscureText: !signupController.isPasswordVisible,
                  onChanged: (value) =>
                      signupController.passwordError.value = '',
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey.shade500),
                    suffixIcon: IconButton(
                      icon: Icon(
                        signupController.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: signupController.togglePasswordVisibility,
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
                        color: signupController.passwordError.value.isNotEmpty
                            ? Colors.red
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    errorText: signupController.passwordError.value.isEmpty
                        ? null
                        : signupController.passwordError.value,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Confirm Password Input
              Obx(
                () => TextField(
                  controller: signupController.confirmPasswordController,
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  obscureText: !signupController.isConfirmPasswordVisible,
                  onChanged: (value) =>
                      signupController.confirmPasswordError.value = '',
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey.shade500),
                    suffixIcon: IconButton(
                      icon: Icon(
                        signupController.isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade500,
                      ),
                      onPressed:
                          signupController.toggleConfirmPasswordVisibility,
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
                        color: signupController
                                .confirmPasswordError.value.isNotEmpty
                            ? Colors.red
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    errorText:
                        signupController.confirmPasswordError.value.isEmpty
                            ? null
                            : signupController.confirmPasswordError.value,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Obx(
                () => ElevatedButton(
                  onPressed: signupController.isLoading.value
                      ? null
                      : () => signupController.signUpWithEmailAndPassword(),
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
                  child: signupController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Sign Up",
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
                      "Or sign up with",
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
                    onPressed: signupController.isLoading.value
                        ? null
                        : () => signupController.signInWithGoogle(),
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
                    heroTag: "googleSignup",
                  ),
                  SizedBox(width: 20.w),

                  _buildSocialButton(
                    onPressed: signupController.isLoading.value
                        ? null
                        : () => signupController.signInWithFacebook(),
                    icon: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.blue.shade800,
                      size: 24.w,
                    ),
                    heroTag: "facebookSignup",
                  ),
                  SizedBox(width: 20.w),

                  _buildSocialButton(
                    onPressed: signupController.isLoading.value
                        ? null
                        : () => signupController.signInWithX(),
                    icon: Icon(
                      FontAwesomeIcons.xTwitter,
                      color: Colors.black,
                      size: 24.w,
                    ),
                    heroTag: "xSignup",
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              TextButton(
                onPressed: () {
                  Get.offAll(() => const LoginScreen());
                },
                child: Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(
                        text: "Login here",
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
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

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
