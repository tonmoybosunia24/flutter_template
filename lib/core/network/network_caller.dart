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

/// Makes the app's HTTP requests: adds auth headers, refreshes expired tokens, retries once after a 401 and turns every outcome into a [ResponseData]. Params: [storage]: token storage. Defaults to the registered [StorageService]. [client]: the HTTP client. Defaults to a new [http.Client]. [connectivityCheck]: tells whether the device is online. Defaults to a check with [Connectivity].
class NetworkCaller {
  
  // Timeout duration for network requests in seconds.
  final _timeoutSeconds = 30;
  final StorageService _storage;
  final http.Client _client;
  final Future<bool> Function() _connectivityCheck;

  // Constructor with optional parameters for storage, client, and connectivity check function
  NetworkCaller({
    StorageService? storage,
    http.Client? client,
    Future<bool> Function()? connectivityCheck,
  }) : _storage = storage ?? Get.find<StorageService>(),
       _client = client ?? http.Client(),
       _connectivityCheck = connectivityCheck ?? _defaultConnectivityCheck;

  // Default connectivity check function
  static Future<bool> _defaultConnectivityCheck() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  // The refresh currently in progress, shared by every request waiting for a new token.
  Completer<bool>? _refreshCompleter;

  // This method ensures that only one token refresh operation is in progress at a time. If a refresh is already in progress, it returns the existing future. Otherwise, it initiates a new refresh operation and returns its future.
  Future<bool> _refreshToken() {
    final inFlight = _refreshCompleter;
    if (inFlight != null) return inFlight.future;

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    unawaited(
      _performRefresh()
          .then((success) {
            _refreshCompleter = null;
            completer.complete(success);
          })
          .catchError((Object e) {
            _refreshCompleter = null;
            AppLogger.logError('Token refresh failed', e);
            completer.complete(false);
          }),
    );

    return completer.future;
  }

  // Method to perform the actual token refresh operation.
  Future<bool> _performRefresh() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      AppLogger.logInfo('Refreshing token...');

      final response = await _client.post(
        Uri.parse(ApiEndpoints.refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded is Map<String, dynamic> ? decoded['data'] : null;

        if (data is Map<String, dynamic>) {
          final accessToken = data['access_token'];
          final refreshToken = data['refresh_token'];
          final expiresIn = data['expires_in'];

          if (accessToken is String && refreshToken is String) {
            await _storage.saveTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
              expiresIn: expiresIn is int ? expiresIn : 0,
            );
            AppLogger.logInfo('Token refreshed successfully');
            return true;
          }
        }
        AppLogger.logError('Refresh response did not contain valid tokens');
      }
    } catch (e) {
      AppLogger.logError('Token refresh failed', e);
    }
    return false;
  }

  // Method to log out the user by clearing authentication data and navigating to the login screen.
  Future<void> _logout() async {
    await _storage.clearAuth();
    await Get.offAllNamed<void>(AppRoutes.login);
  }

  // Method to get headers for network requests, including authorization if needed.
  Future<Map<String, String>> _getHeaders({bool isAuthCall = false}) async {
    var token = await _storage.getAccessToken();

    // Refresh an expired token. Without a token there is no session to refresh, so the request goes out without one.
    if (!isAuthCall && token != null && _storage.isAccessTokenExpired()) {
      final refreshed = await _refreshToken();
      if (!refreshed) await _logout();
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
        final refreshed = await _refreshToken();
        if (refreshed) {
          return await _sendRequest(
            url: url,
            method: method,
            body: body,
            isRetry: true,
          );
        } else {
          await _logout();
          return ResponseData.failure(
            error: AppError.unauthorized,
            statusCode: 401,
          );
        }
      }

      return _handleResponse(response);
    } on TimeoutException {
      return ResponseData.failure(error: AppError.timeout, statusCode: 408);
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

      final errorMsg = decoded is Map ? (decoded['message'] as String?) : null;
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

      return _handleResponse(response);
    } catch (e) {
      AppLogger.logError('Upload error', e);
      return ResponseData.failure(error: AppError.unknown);
    }
  }

}