import 'package:get/get.dart';
import 'package:template/core/localization/langs/ar_sa.dart';
import 'package:template/core/localization/langs/bn_bd.dart';
import 'package:template/core/localization/langs/en_us.dart';

/// Supplies the translation maps of every supported locale to GetX.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ar_SA': arSA,
    'bn_BD': bnBD,
  };
}