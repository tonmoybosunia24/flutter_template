import 'dart:convert';

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

  // A token counts as expired this long before it really runs out, so it can't expire on the way to the server.
  static const Duration expiryBuffer = Duration(seconds: 30);

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

  // Saves both tokens securely and records when the access token expires. [expiresIn] is the server's `expires_in` exactly as sent (seconds as a number or text, or null).
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    Object? expiresIn,
  }) async {
    await _secureStorage.write(
      key: StorageKeys.accessToken,
      value: accessToken,
    );
    await _secureStorage.write(
      key: StorageKeys.refreshToken,
      value: refreshToken,
    );

    // An unknown expiry removes the old one, so the new token never inherits the previous token's expiry. Expiry isn't sensitive data.
    final expiry = resolveExpiry(
      accessToken: accessToken,
      expiresIn: expiresIn,
    );
    if (expiry == null) {
      await _localStorage.remove(StorageKeys.tokenExpiry);
    } else {
      await _localStorage.write(StorageKeys.tokenExpiry, expiry);
    }
  }

  // Method to retrieve the access token from secure storage
  Future<String?> getAccessToken() =>
      _secureStorage.read(key: StorageKeys.accessToken);

  // Method to retrieve the refresh token from secure storage
  Future<String?> getRefreshToken() =>
      _secureStorage.read(key: StorageKeys.refreshToken);

  // Whether the access token should be refreshed before the next request.
  bool isAccessTokenExpired() =>
      isExpiredAt(_localStorage.read<int>(StorageKeys.tokenExpiry));

  // When the access token expires, in milliseconds since epoch: from [expiresIn] first, then from the JWT's `exp` claim. Null when neither exists.
  static int? resolveExpiry({
    required String accessToken,
    Object? expiresIn,
    DateTime? now,
  }) {
    final seconds = expiresIn is num ? expiresIn : num.tryParse('$expiresIn');
    if (seconds != null && seconds > 0) {
      return (now ?? DateTime.now()).millisecondsSinceEpoch +
          (seconds * 1000).round();
    }
    return _jwtExpiry(accessToken);
  }

  // Reads the `exp` claim from a JWT access token. Null when the token isn't a JWT or has no `exp`.
  static int? _jwtExpiry(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = payload is Map ? payload['exp'] : null;
      return exp is num ? (exp * 1000).round() : null;
    } catch (_) {
      return null;
    }
  }

  // Whether a token with [expiry] should be refreshed at [now]. An unknown expiry is never expired, so the server's 401 decides instead.
  static bool isExpiredAt(int? expiry, {DateTime? now}) {
    if (expiry == null) return false;
    final current = (now ?? DateTime.now()).millisecondsSinceEpoch;
    return current >= expiry - expiryBuffer.inMilliseconds;
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
