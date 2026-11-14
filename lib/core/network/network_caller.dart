import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:template/core/network/api_endpoints.dart';
import 'package:template/core/network/app_error.dart';
import 'package:template/core/network/response_data.dart';
import 'package:template/core/storage/storage_service.dart';
import 'package:template/core/utils/logger.dart';
import 'package:template/routes/app_routes.dart';

/// The result of trying to get a new access token: it worked, the server refused the session, the request timed out, the server couldn't be reached, or the server failed.
enum _RefreshResult { refreshed, rejected, timedOut, offline, serverError }

/// Stops a request whose session couldn't be refreshed. Params: [error]: the failure to report. [statusCode]: the status code to report.
class _SessionException implements Exception {
  final AppError error;
  final int statusCode;

  const _SessionException(this.error, this.statusCode);
}

/// Makes the app's HTTP requests: adds auth headers, refreshes expired tokens, retries once after a 401 and turns every outcome into a [ResponseData]. Params: [storage]: token storage. Defaults to the registered [StorageService]. [client]: the HTTP client. Defaults to a new [http.Client]. [connectivityCheck]: tells whether the device is online. Defaults to a check with [Connectivity]. [onSessionExpired]: called after the session is cleared. Defaults to opening the login screen.
class NetworkCaller {
  // Timeout duration for network requests in seconds.
  final _timeoutSeconds = 30;
  final StorageService _storage;
  final http.Client _client;
  final Future<bool> Function() _connectivityCheck;
  final void Function() _onSessionExpired;

  // Constructor with optional parameters for storage, client, connectivity check and session expiry
  NetworkCaller({
    StorageService? storage,
    http.Client? client,
    Future<bool> Function()? connectivityCheck,
    void Function()? onSessionExpired,
  }) : _storage = storage ?? Get.find<StorageService>(),
       _client = client ?? http.Client(),
       _connectivityCheck = connectivityCheck ?? _defaultConnectivityCheck,
       _onSessionExpired = onSessionExpired ?? _goToLogin;

  // Default connectivity check function
  static Future<bool> _defaultConnectivityCheck() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  // Opens the login screen, unless it is already showing. Not awaited, because the navigation's future only completes when the login screen closes.
  static void _goToLogin() {
    if (Get.currentRoute != AppRoutes.login) {
      Get.offAllNamed<void>(AppRoutes.login);
    }
  }

  // The refresh currently in progress, shared by every request waiting for a new token.
  Completer<_RefreshResult>? _refreshCompleter;

  // This method ensures that only one token refresh operation is in progress at a time. If a refresh is already in progress, it returns the existing future. Otherwise, it initiates a new refresh operation and returns its future.
  Future<_RefreshResult> _refreshToken() {
    final inFlight = _refreshCompleter;
    if (inFlight != null) return inFlight.future;

    final completer = Completer<_RefreshResult>();
    _refreshCompleter = completer;

    unawaited(
      _performRefresh()
          .then((result) {
            _refreshCompleter = null;
            completer.complete(result);
          })
          .catchError((Object e) {
            _refreshCompleter = null;
            AppLogger.logError('Token refresh failed', e);
            completer.complete(_RefreshResult.serverError);
          }),
    );

    return completer.future;
  }

  // Method to perform the actual token refresh operation. Only a clear refusal from the server counts as rejected; network errors, timeouts and server errors leave the session alone.
  Future<_RefreshResult> _performRefresh() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return _RefreshResult.rejected;

      AppLogger.logInfo('Refreshing token...');

      final response = await _client
          .post(
            Uri.parse(ApiEndpoints.refreshToken),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(Duration(seconds: _timeoutSeconds));

      if (const [400, 401, 403].contains(response.statusCode)) {
        return _RefreshResult.rejected;
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded is Map<String, dynamic> ? decoded['data'] : null;

        if (data is Map<String, dynamic>) {
          final accessToken = data['access_token'];
          final refreshToken = data['refresh_token'];

          if (accessToken is String && refreshToken is String) {
            await _storage.saveTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
              expiresIn: data['expires_in'],
            );
            AppLogger.logInfo('Token refreshed successfully');
            return _RefreshResult.refreshed;
          }
        }
        AppLogger.logError('Refresh response did not contain valid tokens');
      }
    } on TimeoutException catch (e) {
      AppLogger.logError('Token refresh timed out', e);
      return _RefreshResult.timedOut;
    } on http.ClientException catch (e) {
      AppLogger.logError('Token refresh could not reach the server', e);
      return _RefreshResult.offline;
    } catch (e) {
      AppLogger.logError('Token refresh failed', e);
    }
    return _RefreshResult.serverError;
  }

  // Whether a logout is running, so parallel requests that fail together log out only once.
  bool _isLoggingOut = false;

  // Method to log out the user by clearing authentication data and reporting the expired session.
  Future<void> _logout() async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;
    try {
      await _storage.clearAuth();
      _onSessionExpired();
    } finally {
      _isLoggingOut = false;
    }
  }

  // Gets a new access token, or throws a [_SessionException] so the request stops instead of going out without a valid token.
  Future<void> _refreshOrThrow() async {
    switch (await _refreshToken()) {
      case _RefreshResult.refreshed:
        return;
      case _RefreshResult.rejected:
        await _logout();
        throw const _SessionException(AppError.unauthorized, 401);
      case _RefreshResult.timedOut:
        throw const _SessionException(AppError.timeout, 408);
      case _RefreshResult.offline:
        throw const _SessionException(AppError.noInternet, 0);
      case _RefreshResult.serverError:
        throw _SessionException(AppError.fromStatusCode(500), 500);
    }
  }

  // Method to get headers for network requests, including authorization if needed.
  Future<Map<String, String>> _getHeaders({bool isAuthCall = false}) async {
    var token = await _storage.getAccessToken();

    // Refresh an expired token. Without a token there is no session to refresh, so the request goes out without one.
    if (!isAuthCall && token != null && _storage.isAccessTokenExpired()) {
      await _refreshOrThrow();
      token = await _storage.getAccessToken();
    }

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Sends a request with up to one retry after a 401, and converts connectivity, timeout and other failures into a failed ResponseData.
  Future<ResponseData<dynamic>> _sendRequest({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    bool isAuthCall = false,
    bool isRetry = false,
  }) async {
    if (!await _connectivityCheck()) {
      return ResponseData.failure(error: AppError.noInternet);
    }

    try {
      final headers = await _getHeaders(isAuthCall: isAuthCall);
      AppLogger.logInfo('[$method] $url');
      if (body != null) AppLogger.logDebug('Body: ${jsonEncode(body)}');

      final uri = Uri.parse(url);
      http.Response response;

      switch (method) {
        case 'GET':
          response = await _client
              .get(uri, headers: headers)
              .timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'POST':
          response = await _client
              .post(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'PUT':
          response = await _client
              .put(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'PATCH':
          response = await _client
              .patch(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'DELETE':
          response = await _client
              .delete(uri, headers: headers)
              .timeout(Duration(seconds: _timeoutSeconds));
          break;
        default:
          throw Exception('Invalid HTTP method: $method');
      }

      // Handle Unauthorized (401)
      if (response.statusCode == 401 && !isAuthCall && !isRetry) {
        await _refreshOrThrow();
        return await _sendRequest(
          url: url,
          method: method,
          body: body,
          isRetry: true,
        );
      }

      return _handleResponse(response);
    } on _SessionException catch (e) {
      return ResponseData.failure(error: e.error, statusCode: e.statusCode);
    } on TimeoutException {
      return ResponseData.failure(error: AppError.timeout, statusCode: 408);
    } on http.ClientException catch (e) {
      // Connected to a network that has no internet, or the server can't be reached.
      AppLogger.logError('Could not reach the server', e);
      return ResponseData.failure(error: AppError.noInternet);
    } catch (e) {
      AppLogger.logError('Network error', e);
      return ResponseData.failure(error: AppError.unknown);
    }
  }

  // Method to handle the HTTP response and return a ResponseData object
  ResponseData<dynamic> _handleResponse(http.Response response) {
    AppLogger.logInfo('Status: ${response.statusCode}');
    AppLogger.logDebug('Body: ${response.body}');

    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    // A successful response can have no body at all (e.g. 204 No Content), and an empty string can't be decoded as JSON.
    if (isSuccess && response.body.trim().isEmpty) {
      return ResponseData.success(statusCode: response.statusCode);
    }

    try {
      final decoded = jsonDecode(response.body);

      if (isSuccess) {
        // Handle common API success structures
        if (decoded is Map<String, dynamic> &&
            decoded.containsKey('status') &&
            decoded['status'] == 'success') {
          return ResponseData.success(
            statusCode: response.statusCode,
            data: decoded['data'],
          );
        }
        return ResponseData.success(
          statusCode: response.statusCode,
          data: decoded,
        );
      }

      // Some backends (e.g. NestJS validation) send a list of messages, so show them one per line.
      final errorMsg = switch (decoded is Map ? decoded['message'] : null) {
        final String message when message.isNotEmpty => message,
        final List<dynamic> messages when messages.isNotEmpty => messages.join(
          '\n',
        ),
        _ => null,
      };
      final appError = AppError.fromStatusCode(
        response.statusCode,
        message: errorMsg,
      );

      return ResponseData.failure(
        error: appError,
        statusCode: response.statusCode,
      );
    } catch (e) {
      // The server reported success but the body isn't JSON, so hand back the raw text.
      if (isSuccess) {
        return ResponseData.success(
          statusCode: response.statusCode,
          data: response.body,
        );
      }

      return ResponseData.failure(
        error: AppError.unknown,
        statusCode: response.statusCode,
      );
    }
  }

  // Method to send a GET request
  Future<ResponseData<dynamic>> getRequest(String url) {
    return _sendRequest(url: url, method: 'GET');
  }

  // Method to send a POST request with optional body and authentication flag
  Future<ResponseData<dynamic>> postRequest(
    String url, {
    Map<String, dynamic>? body,
    bool isAuthCall = false,
  }) {
    return _sendRequest(
      url: url,
      method: 'POST',
      body: body,
      isAuthCall: isAuthCall,
    );
  }

  // Method to send a PUT request with optional body
  Future<ResponseData<dynamic>> putRequest(
    String url, {
    Map<String, dynamic>? body,
  }) {
    return _sendRequest(url: url, method: 'PUT', body: body);
  }

  // Method to send a PATCH request with optional body
  Future<ResponseData<dynamic>> patchRequest(
    String url, {
    Map<String, dynamic>? body,
  }) {
    return _sendRequest(url: url, method: 'PATCH', body: body);
  }

  // Method to send a DELETE request
  Future<ResponseData<dynamic>> deleteRequest(String url) {
    return _sendRequest(url: url, method: 'DELETE');
  }

  // Method to send a multipart POST request for file uploads
  Future<ResponseData<dynamic>> multipartPostRequest({
    required String url,
    required Map<String, String> fields,
    required String fileFieldName,
    required String filePath,
  }) {
    return _sendMultipart(
      url: url,
      fields: fields,
      fileFieldName: fileFieldName,
      filePath: filePath,
    );
  }

  // Sends a file upload with up to one retry after a 401. The request is rebuilt for the retry, because a sent multipart request can't be reused.
  Future<ResponseData<dynamic>> _sendMultipart({
    required String url,
    required Map<String, String> fields,
    required String fileFieldName,
    required String filePath,
    bool isRetry = false,
  }) async {
    if (!await _connectivityCheck()) {
      return ResponseData.failure(error: AppError.noInternet);
    }

    try {
      final headers = await _getHeaders();
      final uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        if (headers.containsKey('Authorization'))
          'Authorization': headers['Authorization']!,
      });

      request.fields.addAll(fields);
      request.files.add(
        await http.MultipartFile.fromPath(fileFieldName, filePath),
      );

      AppLogger.logInfo('Uploading to: $url');
      final streamedResponse = await _client
          .send(request)
          .timeout(Duration(seconds: _timeoutSeconds));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401 && !isRetry) {
        await _refreshOrThrow();
        return await _sendMultipart(
          url: url,
          fields: fields,
          fileFieldName: fileFieldName,
          filePath: filePath,
          isRetry: true,
        );
      }

      return _handleResponse(response);
    } on _SessionException catch (e) {
      return ResponseData.failure(error: e.error, statusCode: e.statusCode);
    } on TimeoutException {
      return ResponseData.failure(error: AppError.timeout, statusCode: 408);
    } on http.ClientException catch (e) {
      // Connected to a network that has no internet, or the server can't be reached.
      AppLogger.logError('Upload could not reach the server', e);
      return ResponseData.failure(error: AppError.noInternet);
    } catch (e) {
      AppLogger.logError('Upload error', e);
      return ResponseData.failure(error: AppError.unknown);
    }
  }
}
