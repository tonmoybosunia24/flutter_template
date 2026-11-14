import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:template/core/network/network_caller.dart';
import 'package:template/core/storage/storage_service.dart';

const String _url = 'https://example.com/items';

/// An in-memory [StorageService] with a valid session, so tests never touch the device's storage plugins.
class _FakeStorage extends GetxService implements StorageService {
  _FakeStorage({this.accessToken = 'access', this.expired = false});

  String? accessToken;
  String? refreshToken = 'refresh';
  final bool expired;
  String? savedAccessToken;
  Object? savedExpiresIn;
  int clearAuthCalls = 0;

  @override
  Future<String?> getAccessToken() async => accessToken;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<void> clearAuth() async {
    clearAuthCalls++;
    accessToken = null;
    refreshToken = null;
  }

  @override
  bool isAccessTokenExpired() => expired;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    Object? expiresIn,
  }) async {
    this.accessToken = accessToken;
    savedAccessToken = accessToken;
    savedExpiresIn = expiresIn;
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
      final accepted = await _callerFor(
        202,
        '{"queued":true}',
      ).postRequest(_url);

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

    test(
      'a connection failure on a connected network reports no internet',
      () async {
        final caller = NetworkCaller(
          storage: _FakeStorage(),
          client: MockClient(
            (_) async => throw http.ClientException('offline'),
          ),
          connectivityCheck: () async => true,
        );

        final result = await caller.getRequest(_url);

        expect(result.isSuccess, isFalse);
        expect(result.error?.isNoInternet, isTrue);
      },
    );
  });

  test(
    'a request without a session goes out with no token and no refresh',
    () async {
      final requests = <http.Request>[];
      final caller = NetworkCaller(
        storage: _FakeStorage(accessToken: null, expired: true),
        client: MockClient((request) async {
          requests.add(request);
          return http.Response('{"id":1}', 200);
        }),
        connectivityCheck: () async => true,
      );

      final result = await caller.getRequest(_url);

      expect(result.isSuccess, isTrue);
      expect(requests.map((r) => r.url.toString()), [_url]);
      expect(requests.single.headers.containsKey('Authorization'), isFalse);
    },
  );

  test('an expired token is refreshed before the request', () async {
    final requests = <http.Request>[];
    final caller = NetworkCaller(
      storage: _FakeStorage(expired: true),
      client: MockClient((request) async {
        requests.add(request);
        return request.url.path.endsWith('/auth/refresh')
            ? http.Response(
                '{"data":{"access_token":"new","refresh_token":"r2","expires_in":60}}',
                200,
              )
            : http.Response('{"id":1}', 200);
      }),
      connectivityCheck: () async => true,
    );

    final result = await caller.getRequest(_url);

    expect(result.isSuccess, isTrue);
    expect(requests.first.url.path, endsWith('/auth/refresh'));
    expect(requests.last.url.toString(), _url);
    expect(requests.last.headers['Authorization'], 'Bearer new');
  });

  test('a refresh without expires_in saves no expiry instead of 0', () async {
    final storage = _FakeStorage(expired: true);
    final caller = NetworkCaller(
      storage: storage,
      client: MockClient(
        (request) async => request.url.path.endsWith('/auth/refresh')
            ? http.Response(
                '{"data":{"access_token":"new","refresh_token":"r2"}}',
                200,
              )
            : http.Response('{"id":1}', 200),
      ),
      connectivityCheck: () async => true,
    );

    final result = await caller.getRequest(_url);

    expect(result.isSuccess, isTrue);
    expect(storage.savedAccessToken, 'new');
    expect(storage.savedExpiresIn, isNull);
  });

  group('when the refresh fails', () {
    // Requests made through [caller], and how often the session expired.
    late _FakeStorage storage;
    late List<http.Request> itemRequests;
    late int refreshRequests;
    late int expiredCalls;

    NetworkCaller callerWith(Future<http.Response> Function() refresh) {
      return NetworkCaller(
        storage: storage,
        client: MockClient((request) async {
          if (request.url.path.endsWith('/auth/refresh')) {
            refreshRequests++;
            return refresh();
          }
          itemRequests.add(request);
          return http.Response('{}', 401);
        }),
        connectivityCheck: () async => true,
        onSessionExpired: () => expiredCalls++,
      );
    }

    setUp(() {
      storage = _FakeStorage(expired: true);
      itemRequests = [];
      refreshRequests = 0;
      expiredCalls = 0;
    });

    test('a server error keeps the session and stops the request', () async {
      final result = await callerWith(() async => http.Response('{}', 500))
          .getRequest(_url);

      expect(result.isSuccess, isFalse);
      expect(result.statusCode, 500);
      expect(result.error?.errorCode, 'SERVER_ERROR');
      expect(expiredCalls, 0);
      expect(storage.clearAuthCalls, 0);
      expect(storage.accessToken, 'access');
      expect(itemRequests, isEmpty);
    });

    test('a network error keeps the session', () async {
      final result = await callerWith(
        () async => throw http.ClientException('offline'),
      ).getRequest(_url);

      expect(result.isSuccess, isFalse);
      expect(result.error?.isNoInternet, isTrue);
      expect(expiredCalls, 0);
      expect(storage.refreshToken, 'refresh');
    });

    test('a 401 after a server error on refresh keeps the session', () async {
      storage = _FakeStorage();
      final result = await callerWith(() async => http.Response('{}', 503))
          .getRequest(_url);

      expect(result.isSuccess, isFalse);
      expect(itemRequests, hasLength(1));
      expect(expiredCalls, 0);
      expect(storage.accessToken, 'access');
    });

    test('a rejected refresh logs out and stops the request', () async {
      final result = await callerWith(() async => http.Response('{}', 401))
          .getRequest(_url);

      expect(result.isSuccess, isFalse);
      expect(result.statusCode, 401);
      expect(result.error?.isUnauthorized, isTrue);
      expect(expiredCalls, 1);
      expect(storage.clearAuthCalls, 1);
      expect(itemRequests, isEmpty);
    });

    test('parallel requests refresh once and log out once', () async {
      final caller = callerWith(() async => http.Response('{}', 401));

      final results = await Future.wait([
        caller.getRequest(_url),
        caller.getRequest(_url),
        caller.getRequest(_url),
      ]);

      expect(results.every((r) => !r.isSuccess), isTrue);
      expect(refreshRequests, 1);
      expect(expiredCalls, 1);
      expect(storage.clearAuthCalls, 1);
      expect(itemRequests, isEmpty);
    });

    testWidgets('a refresh that never answers times out', (tester) async {
      final never = Completer<http.Response>();
      final future = callerWith(() => never.future).getRequest(_url);

      await tester.pump();
      await tester.pump(const Duration(seconds: 31));
      final result = await future;

      expect(result.isSuccess, isFalse);
      expect(result.error?.isTimeout, isTrue);
      expect(expiredCalls, 0);
      expect(storage.accessToken, 'access');
      expect(itemRequests, isEmpty);
    });
  });

  group('file uploads', () {
    late Directory tempDir;
    late String filePath;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('network_caller_test');
      filePath = '${tempDir.path}/photo.txt';
      File(filePath).writeAsStringSync('photo');
    });

    tearDown(() => tempDir.deleteSync(recursive: true));

    test('a 401 refreshes the token and sends the file again', () async {
      final storage = _FakeStorage();
      final uploads = <http.Request>[];
      final caller = NetworkCaller(
        storage: storage,
        client: MockClient((request) async {
          if (request.url.path.endsWith('/auth/refresh')) {
            return http.Response(
              '{"data":{"access_token":"new","refresh_token":"r2","expires_in":60}}',
              200,
            );
          }
          uploads.add(request);
          return uploads.length == 1
              ? http.Response('{}', 401)
              : http.Response('{"id":1}', 201);
        }),
        connectivityCheck: () async => true,
      );

      final result = await caller.multipartPostRequest(
        url: _url,
        fields: const {'title': 'Hello'},
        fileFieldName: 'image',
        filePath: filePath,
      );

      expect(result.isSuccess, isTrue);
      expect(result.data, {'id': 1});
      expect(uploads, hasLength(2));
      expect(uploads.last.headers['Authorization'], 'Bearer new');
      expect(uploads.last.body, contains('photo'));
    });

    test('a 401 twice stops after one retry', () async {
      var uploads = 0;
      final caller = NetworkCaller(
        storage: _FakeStorage(),
        client: MockClient((request) async {
          if (request.url.path.endsWith('/auth/refresh')) {
            return http.Response(
              '{"data":{"access_token":"new","refresh_token":"r2","expires_in":60}}',
              200,
            );
          }
          uploads++;
          return http.Response('{}', 401);
        }),
        connectivityCheck: () async => true,
      );

      final result = await caller.multipartPostRequest(
        url: _url,
        fields: const {},
        fileFieldName: 'image',
        filePath: filePath,
      );

      expect(result.isSuccess, isFalse);
      expect(result.statusCode, 401);
      expect(uploads, 2);
    });

    test('a rejected refresh logs out', () async {
      final storage = _FakeStorage();
      var expiredCalls = 0;
      final caller = NetworkCaller(
        storage: storage,
        client: MockClient((_) async => http.Response('{}', 401)),
        connectivityCheck: () async => true,
        onSessionExpired: () => expiredCalls++,
      );

      final result = await caller.multipartPostRequest(
        url: _url,
        fields: const {},
        fileFieldName: 'image',
        filePath: filePath,
      );

      expect(result.error?.isUnauthorized, isTrue);
      expect(expiredCalls, 1);
      expect(storage.clearAuthCalls, 1);
    });

    test('a connection failure reports no internet', () async {
      final caller = NetworkCaller(
        storage: _FakeStorage(),
        client: MockClient((_) async => throw http.ClientException('offline')),
        connectivityCheck: () async => true,
      );

      final result = await caller.multipartPostRequest(
        url: _url,
        fields: const {},
        fileFieldName: 'image',
        filePath: filePath,
      );

      expect(result.error?.isNoInternet, isTrue);
    });
  });

  test('a 401 refreshes the token and retries the request once', () async {
    final storage = _FakeStorage();
    var itemRequests = 0;
    final caller = NetworkCaller(
      storage: storage,
      client: MockClient((request) async {
        if (request.url.path.endsWith('/auth/refresh')) {
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
