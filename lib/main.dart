import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';

import 'AppUi/translations/app_translations.dart';
import 'AppUi/routes/app_pages.dart';
import 'AppUi/routes/app_routes.dart';
import 'AppUi/Controllers/GeneralSettingsController.dart';
import 'core/theme/app_theme.dart';
import 'core/bindings/app_bindings.dart';
import 'config/app_config.dart';
import 'firebase_options.dart';
import 'AppUi/AppScreens/ProfileScreen/GeneralSettings/widgets/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Stripe with all required settings
    Stripe.publishableKey = AppConfig.stripePublishableKey;
    Stripe.merchantIdentifier = AppConfig.stripeMerchantId;
    Stripe.urlScheme = 'flutterstripe';
    await Stripe.instance.applySettings();

    // Initialize async dependencies first
    await AppBindings.initializeAsync();
    
    // Then register all controllers
    AppBindings().dependencies();
  } catch (e) {
    print("Initialization error: $e");
    // Ensure Firebase is still initialized so the app can function
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (firebaseInitError) {
      print('Firebase fallback initialization failed: $firebaseInitError');
    }
    // Fallback: Ensure services/controllers are registered so app screens can resolve them
    try {
      // Register NotificationService first because ChatBotController depends on it
      final NotificationService notificationService = Get.put(NotificationService(), permanent: true);
      await notificationService.init();
      AppBindings().dependencies();
    } catch (_) {
      if (!Get.isRegistered<GeneralSettingsController>()) {
        Get.put(GeneralSettingsController(), permanent: true);
      }
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Double-check that the controller is registered
    if (!Get.isRegistered<GeneralSettingsController>()) {
      Get.put(GeneralSettingsController(), permanent: true);
    }
    
    final settingsController = Get.find<GeneralSettingsController>();

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() {
          return GetMaterialApp(
            translations: AppTranslations(),
            locale: settingsController.currentLocale.value,
            fallbackLocale: const Locale('en'),
            debugShowCheckedModeBanner: false,
            title: 'Emvibe Chatbot',
            themeMode: settingsController.themeMode.value,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            initialRoute: Routes.splash,
            getPages: AppPages.pages,
          );
        });
      },
    );
  }
}