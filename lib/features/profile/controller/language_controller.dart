import 'package:get/get.dart';
import 'package:template/core/core.dart';

/// Manages the language screen: the languages on offer and the one picked but not saved yet. Each language is a record of (language code, name in its own language, translation key of its translated name).
class LanguageController extends GetxController {
  final List<(String, String, String)> suggestedLanguages = const [
    (StorageKeys.langCodeEn, 'English (US)', AppStrings.languageEnglish),
    (StorageKeys.langCodeBn, 'বাংলা', AppStrings.languageBengali),
  ];

  final List<(String, String, String)> otherLanguages = const [
    (StorageKeys.langCodeAr, 'العربية', AppStrings.languageArabic),
  ];

  // The language highlighted on the screen. Starts as the app's current language.
  late final RxString selectedCode = SettingsUtil.currentLanguage.value.obs;

  // Highlights the language with [code].
  void select(String code) => selectedCode.value = code;

  // Applies and saves the highlighted language, then returns to the previous screen.
  void save() {
    final code = selectedCode.value;
    Get.back<void>();
    SettingsUtil.changeLanguage(code);
  }
}
