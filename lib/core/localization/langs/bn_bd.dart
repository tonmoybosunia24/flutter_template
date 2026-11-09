import 'package:template/core/utils/app_strings.dart';

/// Bengali (Bangladesh) translations, keyed by [AppStrings].
const Map<String, String> bnBD = {
  AppStrings.appName: 'ফ্লাটার টেমপ্লেট',
  AppStrings.splashTitle: 'ফ্লাটার টেমপ্লেট',

  // Onboarding
  AppStrings.onboardingSkip: 'এড়িয়ে যান',
  AppStrings.onboardingNext: 'পরবর্তী',
  AppStrings.onboardingGetStarted: 'শুরু করুন',
  AppStrings.onboardingTitle1: 'স্বাগতম',
  AppStrings.onboardingDesc1: 'শুরু করার জন্য যা কিছু দরকার, সব এক জায়গায়।',
  AppStrings.onboardingTitle2: 'আপডেট থাকুন',
  AppStrings.onboardingDesc2:
      'সময়মতো নোটিফিকেশন পান, যাতে গুরুত্বপূর্ণ কিছু মিস না হয়।',
  AppStrings.onboardingTitle3: 'নিজের মতো সাজান',
  AppStrings.onboardingDesc3: 'আপনার কাজের ধরন অনুযায়ী সেটিংস সাজিয়ে নিন।',

  // Login
  AppStrings.loginTitle: 'আবার স্বাগতম!',
  AppStrings.loginEmailHint: 'আপনার ইমেইল লিখুন',
  AppStrings.loginPasswordHint: 'আপনার পাসওয়ার্ড লিখুন',
  AppStrings.loginRememberMe: 'মনে রাখুন',
  AppStrings.loginSignIn: 'সাইন ইন',
  AppStrings.loginForgotPassword: 'পাসওয়ার্ড ভুলে গেছেন?',
  AppStrings.loginOrContinueWith: 'অথবা এভাবে চালিয়ে যান',
  AppStrings.loginNoAccount: 'অ্যাকাউন্ট নেই?',
  AppStrings.loginSignUp: 'সাইন আপ',

  // Main screen tabs
  AppStrings.navHome: 'হোম',
  AppStrings.navSearch: 'খুঁজুন',
  AppStrings.navNotifications: 'নোটিফিকেশন',
  AppStrings.navSettings: 'সেটিংস',
  AppStrings.navProfile: 'প্রোফাইল',

  // Coming soon
  AppStrings.comingSoon: 'শীঘ্রই আসছে',
  AppStrings.comingSoonMessage: 'আমরা এটি নিয়ে কাজ করছি। শীঘ্রই আবার দেখুন।',

  // Home
  AppStrings.homeLikeCount: '@countটি লাইক',
  AppStrings.homeViewComments: '@countটি মন্তব্য দেখুন',
  AppStrings.homeSave: 'সেভ করুন',
  AppStrings.homeJustNow: 'এইমাত্র',
  AppStrings.homeMinutesAgo: '@count মিনিট আগে',
  AppStrings.homeHoursAgo: '@count ঘণ্টা আগে',
  AppStrings.homeDaysAgo: '@count দিন আগে',
  AppStrings.homeLike: 'লাইক',
  AppStrings.homeComment: 'মন্তব্য',
  AppStrings.homeShare: 'শেয়ার',
  AppStrings.homeCreatePostHint: 'পোস্টের শিরোনাম লিখুন...',
  AppStrings.homeCreatePostSubmit: 'পোস্ট করুন',
  AppStrings.homeWelcomeBack: 'আবার স্বাগতম',

  // Profile
  AppStrings.profileAccountSettings: 'অ্যাকাউন্ট সেটিংস',
  AppStrings.profileMyAccount: 'আমার অ্যাকাউন্ট',
  AppStrings.profileChangePassword: 'পাসওয়ার্ড পরিবর্তন',
  AppStrings.profileNotification: 'নোটিফিকেশন',
  AppStrings.profilePreferences: 'পছন্দসমূহ',
  AppStrings.profileTheme: 'থিম',
  AppStrings.profileLanguage: 'ভাষা',
  AppStrings.profileCurrentLanguage: 'বাংলা',
  AppStrings.profilePayment: 'পেমেন্ট',
  AppStrings.profileUpgradePremium: 'প্রিমিয়ামে আপগ্রেড করুন',
  AppStrings.profileSupport: 'সহায়তা',
  AppStrings.profileHelpCenter: 'সহায়তা কেন্দ্র',
  AppStrings.profileTerms: 'শর্তাবলী',
  AppStrings.profilePrivacy: 'প্রাইভেসি পলিসি',
  AppStrings.profileLogout: 'লগ আউট',

  // Language names
  AppStrings.languageEnglish: 'ইংরেজি',
  AppStrings.languageBengali: 'বাংলা',
  AppStrings.languageArabic: 'আরবি',
  AppStrings.languageSuggested: 'প্রস্তাবিত',
  AppStrings.languageOthers: 'অন্যান্য',
  AppStrings.languageSave: 'সংরক্ষণ',

  // Errors
  AppStrings.errorUnknown: 'একটি অপ্রত্যাশিত সমস্যা হয়েছে।',
  AppStrings.errorNoInternet: 'ইন্টারনেট সংযোগ নেই।',
  AppStrings.errorTimeout: 'অনুরোধের সময় শেষ হয়ে গেছে। আবার চেষ্টা করুন।',
  AppStrings.errorSessionExpired: 'সেশনের মেয়াদ শেষ। আবার লগ ইন করুন।',
  AppStrings.errorBadRequest: 'অনুরোধটি সঠিক নয়।',
  AppStrings.errorUnauthorized: 'অনুমতি নেই।',
  AppStrings.errorForbidden: 'প্রবেশাধিকার নেই।',
  AppStrings.errorNotFound: 'কিছু খুঁজে পাওয়া যায়নি।',
  AppStrings.errorValidation: 'যাচাই ব্যর্থ হয়েছে।',
  AppStrings.errorServer: 'সার্ভারে সমস্যা হয়েছে।',
  AppStrings.errorRequestFailed: 'অনুরোধ ব্যর্থ হয়েছে।',
  AppStrings.errorRetry: 'আবার চেষ্টা করুন',

  // Form validation
  AppStrings.validationEmailRequired: 'ইমেইল দিতে হবে',
  AppStrings.validationEmailInvalid: 'সঠিক ইমেইল লিখুন',
  AppStrings.validationPasswordRequired: 'পাসওয়ার্ড দিতে হবে',
  AppStrings.validationPasswordTooShort: 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে',
  AppStrings.validationFieldRequired: '@field পূরণ করতে হবে',
  AppStrings.validationFieldDefault: 'ঘরটি',
};