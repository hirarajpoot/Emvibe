import 'package:get/get.dart';
import 'general_settings_translations.dart';
import 'profile_screen_translations.dart';
import 'sidebar_translations.dart';
import 'chatbot_screen_translations.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'en': {
        ...generalSettingsTranslations['en']!,
        ...profileScreenTranslations['en']!,
        ...sidebarTranslations['en']!,
        ...chatbotScreenTranslations['en']!,
      },
      'ur': {
        ...generalSettingsTranslations['ur']!,
        ...profileScreenTranslations['ur']!,
        ...sidebarTranslations['ur']!,
        ...chatbotScreenTranslations['ur']!,
      },
      'hi': {
        ...generalSettingsTranslations['hi']!,
        ...profileScreenTranslations['hi']!,
        ...sidebarTranslations['hi']!,
        ...chatbotScreenTranslations['hi']!,
      },
      'ar': {
        ...generalSettingsTranslations['ar']!,
        ...profileScreenTranslations['ar']!,
        ...sidebarTranslations['ar']!,
        ...chatbotScreenTranslations['ar']!,
      },
      'fr': {
        ...generalSettingsTranslations['fr']!,
        ...profileScreenTranslations['fr']!,
        ...sidebarTranslations['fr']!,
        ...chatbotScreenTranslations['fr']!,
      },
      'es': {
        ...generalSettingsTranslations['es']!,
        ...profileScreenTranslations['es']!,
        ...sidebarTranslations['es']!,
        ...chatbotScreenTranslations['es']!,
      },
      'de': {
        ...generalSettingsTranslations['de']!,
        ...profileScreenTranslations['de']!,
        ...sidebarTranslations['de']!,
        ...chatbotScreenTranslations['de']!,
      },
      'zh': {
        ...generalSettingsTranslations['zh']!,
        ...profileScreenTranslations['zh']!,
        ...sidebarTranslations['zh']!,
        ...chatbotScreenTranslations['zh']!,
      },
    };
  }
}