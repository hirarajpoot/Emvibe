import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'AppUi/Controllers/chatbot_controller.dart';
import 'AppUi/AppScreens/chatbot/chatbot_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ChatBotController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800), 
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: const ChatBotPage(),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}
