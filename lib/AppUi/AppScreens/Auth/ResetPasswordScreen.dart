import 'package:flutter/material.dart';
// import 'package:get/get.dart'; 

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Reset Password", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          "Reset Password Screen (Abhi banega)", 
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}