import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'AppUi/translations/app_translations.dart';
import 'AppUi/routes/app_pages.dart';
import 'AppUi/routes/app_routes.dart';
import 'AppUi/Controllers/GeneralSettingsController.dart';
import 'core/theme/app_theme.dart';
import 'core/bindings/app_bindings.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = AppConfig.stripePublishableKey;

  // Centralized async initialization
  await AppBindings.initializeAsync();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Centralized GetX bindings
    AppBindings().dependencies();

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
            // initialRoute: Routes.splash,
            initialRoute:Routes.chat,
            getPages: AppPages.pages,
          );
        });
      },
    );
  }
}
