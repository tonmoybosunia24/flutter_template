import 'package:template/core/network/app_error.dart';

/// The result of a network call, successful or not. Params: [isSuccess]: whether the request succeeded. [statusCode]: HTTP status code, or 0 when the request failed before a response. [data]: the parsed response body on success. [error]: what went wrong on failure.
class ResponseData<T> {
  final bool isSuccess;
  final int statusCode;
  final T? data;
  final AppError? error;

  const ResponseData({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.error,
  });

  // Factory constructor for creating a successful response with optional data and status code
  factory ResponseData.success({required int statusCode, T? data}) {
    return ResponseData<T>(isSuccess: true, statusCode: statusCode, data: data);
  }

  // Factory constructor for creating a failure response with an error and optional status code
  factory ResponseData.failure({required AppError error, int statusCode = 0}) {
    return ResponseData<T>(
      isSuccess: false,
      statusCode: statusCode,
      error: error,
    );
  }

  // Getter to retrieve the response data if the request was successful
  T? get responseData => data;
  // Getter to retrieve the error message if the request failed
  String get errorMessage => error?.message ?? '';

  // Method to create a copy of the current ResponseData instance with optional new values for its properties
  ResponseData<T> copyWith({
    bool? isSuccess,
    int? statusCode,
    T? data,
    AppError? error,
  }) {
    return ResponseData<T>(
      isSuccess: isSuccess ?? this.isSuccess,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  // Method to transform the data in the response, if the request was successful
  ResponseData<R> mapData<R>(R Function(T data) mapper) {
    if (isSuccess && data != null) {
      return ResponseData<R>.success(
        statusCode: statusCode,
        data: mapper(data as T),
      );
    }
    return ResponseData<R>.failure(
      error: error ?? AppError.unknown,
      statusCode: statusCode,
    );
  }

  // A readable summary of this response, for logs and debugging.
  @override
  String toString() =>
      'ResponseData(isSuccess: $isSuccess, statusCode: $statusCode, error: $error)';
}
