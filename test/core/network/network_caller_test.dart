import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:template/core/network/network_caller.dart';
import 'package:template/core/storage/storage_service.dart';

const String _url = 'https://example.com/items';

/// An in-memory [StorageService] with a valid session, so tests never touch the device's storage plugins.
class _FakeStorage extends GetxService implements StorageService {
  String? savedAccessToken;

  @override
  Future<String?> getAccessToken() async => 'access';

  @override
  Future<String?> getRefreshToken() async => 'refresh';

  @override
  bool isAccessTokenExpired() => false;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    savedAccessToken = accessToken;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Creates a [NetworkCaller] whose every request gets the given [status] and [body].
NetworkCaller _callerFor(int status, String body) => NetworkCaller(
  storage: _FakeStorage(),
  client: MockClient((_) async => http.Response(body, status)),
  connectivityCheck: () async => true,
);

/// Tests how [NetworkCaller] turns server responses into a ResponseData.
void main() {
  group('successful responses', () {
    test('204 with an empty body is a success', () async {
      final result = await _callerFor(204, '').deleteRequest(_url);

      expect(result.isSuccess, isTrue);
      expect(result.statusCode, 204);
      expect(result.data, isNull);
    });

    test('200 unwraps the status/data envelope', () async {
      final result = await _callerFor(
        200,
        '{"status":"success","data":{"id":1}}',
      ).getRequest(_url);

      expect(result.isSuccess, isTrue);
      expect(result.data, {'id': 1});
    });

    test('200 with plain JSON keeps the whole body', () async {
      final result = await _callerFor(200, '[1,2]').getRequest(_url);

      expect(result.isSuccess, isTrue);
      expect(result.data, [1, 2]);
    });

    test('every 2xx status counts as a success', () async {
      final created = await _callerFor(201, '{"id":5}').postRequest(_url);
      final accepted = await _callerFor(202, '{"queued":true}').postRequest(_url);

      expect(created.isSuccess, isTrue);
      expect(accepted.isSuccess, isTrue);
      expect(accepted.statusCode, 202);
    });

    test('a non-JSON body comes back as raw text', () async {
      final result = await _callerFor(200, 'OK').getRequest(_url);

      expect(result.isSuccess, isTrue);
      expect(result.data, 'OK');
    });
  });

  group('failed responses', () {
    test('400 keeps the message sent by the server', () async {
      final result = await _callerFor(
        400,
        '{"message":"Bad email"}',
      ).postRequest(_url);

      expect(result.isSuccess, isFalse);
      expect(result.statusCode, 400);
      expect(result.errorMessage, 'Bad email');
    });

    test('502 with an HTML body is a failure', () async {
      final result = await _callerFor(
        502,
        '<html>Bad Gateway</html>',
      ).getRequest(_url);

      expect(result.isSuccess, isFalse);
      expect(result.statusCode, 502);
    });

    test('500 with an empty body is a failure', () async {
      final result = await _callerFor(500, '').getRequest(_url);

      expect(result.isSuccess, isFalse);
      expect(result.statusCode, 500);
    });

    test('no internet fails without sending the request', () async {
      var requests = 0;
      final caller = NetworkCaller(
        storage: _FakeStorage(),
        client: MockClient((_) async {
          requests++;
          return http.Response('{}', 200);
        }),
        connectivityCheck: () async => false,
      );

      final result = await caller.getRequest(_url);

      expect(result.isSuccess, isFalse);
      expect(result.error?.isNoInternet, isTrue);
      expect(requests, 0);
    });
  });

  test('a 401 refreshes the token and retries the request once', () async {
    final storage = _FakeStorage();
    var itemRequests = 0;
    final caller = NetworkCaller(
      storage: storage,
      client: MockClient((request) async {
        if (request.url.path == '/auth/refresh') {
          return http.Response(
            '{"data":{"access_token":"new","refresh_token":"r2","expires_in":60}}',
            200,
          );
        }
        itemRequests++;
        return itemRequests == 1
            ? http.Response('{}', 401)
            : http.Response('{"id":1}', 200);
      }),
      connectivityCheck: () async => true,
    );

    final result = await caller.getRequest(_url);

    expect(result.isSuccess, isTrue);
    expect(result.data, {'id': 1});
    expect(itemRequests, 2);
    expect(storage.savedAccessToken, 'new');
  });
}
