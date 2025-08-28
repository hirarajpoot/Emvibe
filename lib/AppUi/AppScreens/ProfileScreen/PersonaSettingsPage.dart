// PersonaSettingsPage.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Controllers/chatbot_controller.dart';
import '../../Controllers/GeneralSettingsController.dart'; // 🔥 New: Import GeneralSettingsController

class PersonaSettingsPage extends StatelessWidget {
  const PersonaSettingsPage({super.key});

  // 🔥 Update to use translation keys for dynamic text
  final List<String> personas = const [
    'friendly_persona',
    'formal_persona',
    'casual_persona',
    'motivational_persona',
    'sarcastic_persona',
    'empathetic_persona',
  ];

  final Map<String, String> personaEmojis = const {
    'friendly_persona': '😊',
    'formal_persona': '🤵',
    'casual_persona': '😎',
    'motivational_persona': '🌟',
    'sarcastic_persona': '😏',
    'empathetic_persona': '🤝',
  };

  @override
  Widget build(BuildContext context) {
    final ChatBotController c = Get.find();
    final GeneralSettingsController settingsController = Get.find<GeneralSettingsController>(); // 🔥 New: Get theme controller

    return Obx(() {
      final isDarkMode = settingsController.isDarkMode.value;
      final backgroundColor = isDarkMode ? Colors.black : Colors.white;
      final appBarColor = isDarkMode ? Colors.black : Colors.grey.shade50;
      final iconColor = isDarkMode ? Colors.white : Colors.black;
      final textColor = isDarkMode ? Colors.white : Colors.black;
      final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0.5,
          iconTheme: IconThemeData(color: iconColor),
          title: Text(
            "change_persona_title".tr, // 🔥 Translated title
            style: TextStyle(
              color: textColor,
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
                "select_persona_prompt".tr, // 🔥 Translated prompt
                style: TextStyle(color: subTextColor, fontSize: 16.sp),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView.builder(
                  itemCount: personas.length,
                  itemBuilder: (context, index) {
                    final personaKey = personas[index]; // Use the key
                    final emoji = personaEmojis[personaKey] ?? '';

                    return Obx(() {
                      final isSelected = c.currentPersona.value == personaKey;
                      final cardColor = isSelected
                          ? (isDarkMode ? Colors.blue.shade700 : Colors.blue.shade200)
                          : (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100);
                      final cardBorderColor = isSelected
                          ? (isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600)
                          : Colors.transparent;

                      return Card(
                        color: cardColor,
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: cardBorderColor,
                            width: 1.w,
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          title: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '$emoji ',
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                                TextSpan(
                                  text: personaKey.tr, // 🔥 Translate the persona name
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            c.updatePersona(personaKey);
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
    });
  }
}