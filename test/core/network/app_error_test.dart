import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:template/core/localization/app_translations.dart';
import 'package:template/core/network/app_error.dart';

const Locale _english = Locale('en', 'US');
const Locale _bengali = Locale('bn', 'BD');
const Locale _arabic = Locale('ar', 'SA');

/// Tests that [AppError] messages are shown in the current language.
void main() {
  setUpAll(() => Get.addTranslations(AppTranslations().keys));
  setUp(() => Get.locale = _english);

  test('a predefined error reads in the current language', () {
    expect(AppError.noInternet.message, 'No internet connection.');

    Get.locale = _bengali;
    expect(AppError.noInternet.message, 'ইন্টারনেট সংযোগ নেই।');

    Get.locale = _arabic;
    expect(AppError.noInternet.message, 'لا يوجد اتصال بالإنترنت.');
  });

  test('a status code error has a translated default message', () {
    final error = AppError.fromStatusCode(404);

    expect(error.message, 'Resource not found.');
    expect(error.errorCode, 'NOT_FOUND');

    Get.locale = _bengali;
    expect(error.message, 'কিছু খুঁজে পাওয়া যায়নি।');
  });

  test('a message from the server stays as it was sent', () {
    Get.locale = _bengali;

    expect(AppError.fromStatusCode(400, message: 'Bad email').message, 'Bad email');
  });

  test('copyWith keeps the message translatable', () {
    final copy = AppError.timeout.copyWith(statusCode: 0);

    Get.locale = _bengali;
    expect(copy.message, 'অনুরোধের সময় শেষ হয়ে গেছে। আবার চেষ্টা করুন।');
  });
}
