import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';

import 'package:emvibe/firebase_options.dart';
import 'package:emvibe/AppUi/Controllers/GeneralSettingsController.dart';
import 'package:emvibe/AppUi/Controllers/chatbot_controller.dart';
import 'package:emvibe/AppUi/Controllers/subscription_controller.dart';
import 'package:emvibe/AppUi/AppScreens/ProfileScreen/GeneralSettings/widgets/notification_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(GeneralSettingsController());
    Get.put(ChatBotController());
    Get.put(SubscriptionController());
  }

  static Future<void> initializeAsync() async {
    // Ensure Flutter binding and storage before Firebase
    await GetStorage.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize NotificationService after Firebase is ready
    final NotificationService notificationService = Get.put(NotificationService(), permanent: true);
    await notificationService.init();
  }
}
