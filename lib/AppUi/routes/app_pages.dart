import 'package:get/get.dart';
import '../AppScreens/chatbot/chatbot_page.dart';
// import '../../Controllers/bindings/chatbot_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.chat,
      page: () => const ChatBotPage(),
      // binding: ChatBotBinding(), // ✅ Controller inject here
    ),
  ];
}
