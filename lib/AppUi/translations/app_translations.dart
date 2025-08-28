// Your existing AppTranslations.dart file
import 'package:get/get.dart';
import 'general_settings_translations.dart';
import 'profile_screen_translations.dart';
import 'sidebar_translations.dart';
import 'chatbot_screen_translations.dart';
import 'attachment_box_translations.dart';
import 'top_app_bar_translations.dart';
import 'persona_translations.dart'; // 🔥 New: Import persona translations

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'en': {
        ...generalSettingsTranslations['en']!,
        ...profileScreenTranslations['en']!,
        ...sidebarTranslations['en']!,
        ...chatbotScreenTranslations['en']!,
        ...attachmentBoxTranslations['en']!,
        ...topAppBarTranslations['en']!,
        ...personaTranslations['en']!, // 🔥 New: Add persona translations
      },
      'ur': {
        ...generalSettingsTranslations['ur']!,
        ...profileScreenTranslations['ur']!,
        ...sidebarTranslations['ur']!,
        ...chatbotScreenTranslations['ur']!,
        ...attachmentBoxTranslations['ur']!,
        ...topAppBarTranslations['ur']!,
        ...personaTranslations['ur']!, // 🔥 New: Add persona translations
      },
      'hi': {
        ...generalSettingsTranslations['hi']!,
        ...profileScreenTranslations['hi']!,
        ...sidebarTranslations['hi']!,
        ...chatbotScreenTranslations['hi']!,
        ...attachmentBoxTranslations['hi']!,
        ...topAppBarTranslations['hi']!,
        ...personaTranslations['hi']!, // 🔥 New: Add persona translations
      },
      'ar': {
        ...generalSettingsTranslations['ar']!,
        ...profileScreenTranslations['ar']!,
        ...sidebarTranslations['ar']!,
        ...chatbotScreenTranslations['ar']!,
        ...attachmentBoxTranslations['ar']!,
        ...topAppBarTranslations['ar']!,
        ...personaTranslations['ar']!, // 🔥 New: Add persona translations
      },
      'fr': {
        ...generalSettingsTranslations['fr']!,
        ...profileScreenTranslations['fr']!,
        ...sidebarTranslations['fr']!,
        ...chatbotScreenTranslations['fr']!,
        ...attachmentBoxTranslations['fr']!,
        ...topAppBarTranslations['fr']!,
        ...personaTranslations['fr']!, // 🔥 New: Add persona translations
      },
      'es': {
        ...generalSettingsTranslations['es']!,
        ...profileScreenTranslations['es']!,
        ...sidebarTranslations['es']!,
        ...chatbotScreenTranslations['es']!,
        ...attachmentBoxTranslations['es']!,
        ...topAppBarTranslations['es']!,
        ...personaTranslations['es']!, // 🔥 New: Add persona translations
      },
      'de': {
        ...generalSettingsTranslations['de']!,
        ...profileScreenTranslations['de']!,
        ...sidebarTranslations['de']!,
        ...chatbotScreenTranslations['de']!,
        ...attachmentBoxTranslations['de']!,
        ...topAppBarTranslations['de']!,
        ...personaTranslations['de']!, // 🔥 New: Add persona translations
      },
      'zh': {
        ...generalSettingsTranslations['zh']!,
        ...profileScreenTranslations['zh']!,
        ...sidebarTranslations['zh']!,
        ...chatbotScreenTranslations['zh']!,
        ...attachmentBoxTranslations['zh']!,
        ...topAppBarTranslations['zh']!,
        ...personaTranslations['zh']!, // 🔥 New: Add persona translations
      },
    };
  }
}