import 'package:get/get.dart';
import 'package:template/core/localization/langs/ar_sa.dart';
import 'package:template/core/localization/langs/bn_bd.dart';
import 'package:template/core/localization/langs/en_us.dart';

/// This class is responsible for managing the application's translations. It extends [Translations] from the GetX package, allowing for easy localization support.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ar_SA': arSA,
    'bn_BD': bnBD,
  };
}