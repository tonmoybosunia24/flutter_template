import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:template/core/storage/storage_keys.dart';

/// Saves and reads app data: preferences in [GetStorage] and auth tokens in [FlutterSecureStorage].
class StorageService extends GetxService {
  // Storage instances for local and secure storage
  final GetStorage _localStorage = GetStorage();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  // Methods for saving and retrieving theme
  Future<void> saveTheme(String theme) async =>
      _localStorage.write(StorageKeys.themeMode, theme);
  String? getTheme() => _localStorage.read<String>(StorageKeys.themeMode);

  // Methods for saving and retrieving language
  Future<void> saveLanguage(String lang) async =>
      _localStorage.write(StorageKeys.langCode, lang);
  String? getLanguage() => _localStorage.read<String>(StorageKeys.langCode);

  // Methods for checking if the user has onboarded
  bool hasOnboarded() =>
      _localStorage.read<bool>(StorageKeys.hasOnboarded) ?? false;

  Future<void> setOnboarded() async =>
      _localStorage.write(StorageKeys.hasOnboarded, true);

  // Saves both tokens securely and records when the access token expires. [expiresIn] is in seconds.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    // Save tokens securely and store the expiry time in local storage
    await _secureStorage.write(
      key: StorageKeys.accessToken,
      value: accessToken,
    );
    await _secureStorage.write(
      key: StorageKeys.refreshToken,
      value: refreshToken,
    );

    final expiryTime =
        DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
    await _localStorage.write(StorageKeys.tokenExpiry, expiryTime); // Store the expiry time in milliseconds since epoch. Expiry isn't sensitive data.
  }

  // Method to retrieve the access token from secure storage
  Future<String?> getAccessToken() =>
      _secureStorage.read(key: StorageKeys.accessToken);

  // Method to retrieve the refresh token from secure storage
  Future<String?> getRefreshToken() =>
      _secureStorage.read(key: StorageKeys.refreshToken);

  // Method to check if the access token has expired
  bool isAccessTokenExpired() {
    final expiry = _localStorage.read<int>(StorageKeys.tokenExpiry);
    if (expiry == null) return true;
    return DateTime.now().millisecondsSinceEpoch > expiry;
  }

  // Method to clear authentication data
  Future<void> clearAuth() async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.refreshToken);
    await _localStorage.remove(StorageKeys.tokenExpiry);
  }

  // Method to clear all stored data
  Future<void> clearAll() async {
    await _localStorage.erase();
    await _secureStorage.deleteAll();
  }
}
