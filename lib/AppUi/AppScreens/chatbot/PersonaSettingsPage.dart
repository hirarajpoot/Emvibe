import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Controllers/chatbot_controller.dart';

class PersonaSettingsPage extends StatelessWidget {
  const PersonaSettingsPage({super.key});

  final List<String> personas = const [
    'Friendly',
    'Formal',
    'Casual',
    'Motivational',
    'Sarcastic',
    'Empathetic',
  ];

  final Map<String, String> personaEmojis = const {
    'Friendly': '😊',
    'Formal': '🤵',
    'Casual': '😎',
    'Motivational': '🌟',
    'Sarcastic': '😏',
    'Empathetic': '🤝',
  };

  @override
  Widget build(BuildContext context) {
    final ChatBotController c = Get.find();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Change Persona",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select your preferred chatbot persona:",
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: personas.length,
                itemBuilder: (context, index) {
                  final persona = personas[index];
                  final emoji = personaEmojis[persona] ?? '';

                  return Obx(() {
                    return Card(
                      color: c.currentPersona.value == persona
                          ? Colors.blue.shade700
                          : Colors.grey.shade900,
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: c.currentPersona.value == persona
                              ? Colors.blue.shade300
                              : Colors.transparent,
                          width: 1.w,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          c.currentPersona.value == persona
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: Colors.white,
                        ),
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$emoji ',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                              TextSpan(
                                text: persona,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          c.updatePersona(persona);
                          Get.back(); 
                        },
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
