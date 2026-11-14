import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:template/core/storage/storage_service.dart';

final DateTime _now = DateTime.utc(2026, 1, 1);
final int _nowMs = _now.millisecondsSinceEpoch;

/// Builds an unsigned JWT whose payload is [claims]. The app never checks the signature, so any text works.
String _jwt(Map<String, dynamic> claims) {
  String part(Object json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  return '${part({'alg': 'HS256'})}.${part(claims)}.signature';
}

/// Tests how [StorageService] works out and checks the access token's expiry.
void main() {
  group('resolveExpiry', () {
    test('reads expires_in sent as a number', () {
      expect(
        StorageService.resolveExpiry(
          accessToken: 'opaque',
          expiresIn: 3600,
          now: _now,
        ),
        _nowMs + 3600000,
      );
      expect(
        StorageService.resolveExpiry(
          accessToken: 'opaque',
          expiresIn: 3600.0,
          now: _now,
        ),
        _nowMs + 3600000,
      );
    });

    test('reads expires_in sent as text', () {
      expect(
        StorageService.resolveExpiry(
          accessToken: 'opaque',
          expiresIn: '3600',
          now: _now,
        ),
        _nowMs + 3600000,
      );
    });

    test('prefers expires_in over the JWT exp', () {
      expect(
        StorageService.resolveExpiry(
          accessToken: _jwt({'exp': 999}),
          expiresIn: 60,
          now: _now,
        ),
        _nowMs + 60000,
      );
    });

    test('falls back to the JWT exp when expires_in is missing', () {
      final exp = _nowMs ~/ 1000 + 900;
      expect(
        StorageService.resolveExpiry(accessToken: _jwt({'exp': exp})),
        exp * 1000,
      );
    });

    test('is unknown when neither expires_in nor a JWT exp exists', () {
      expect(StorageService.resolveExpiry(accessToken: 'opaque-token'), isNull);
      expect(
        StorageService.resolveExpiry(accessToken: _jwt({'sub': '42'})),
        isNull,
      );
      expect(StorageService.resolveExpiry(accessToken: 'not.a.jwt'), isNull);
      expect(
        StorageService.resolveExpiry(accessToken: 'opaque', expiresIn: 0),
        isNull,
      );
    });
  });

  group('isExpiredAt', () {
    test('an unknown expiry never counts as expired', () {
      expect(StorageService.isExpiredAt(null, now: _now), isFalse);
    });

    test('a token with plenty of time left is valid', () {
      expect(StorageService.isExpiredAt(_nowMs + 60000, now: _now), isFalse);
    });

    test('a token inside the 30 second buffer counts as expired', () {
      expect(StorageService.isExpiredAt(_nowMs + 10000, now: _now), isTrue);
    });

    test('a token past its expiry is expired', () {
      expect(StorageService.isExpiredAt(_nowMs - 1, now: _now), isTrue);
    });
  });
}
