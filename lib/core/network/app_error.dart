/// An application-level error that the UI can show or branch on. Params: [message]: human-readable text for the user. [statusCode]: HTTP status code, if the error came from a response. [errorCode]: machine-readable code for conditional UI logic.
class AppError {
  
  final String message;
  final int? statusCode;
  final String? errorCode;
  const AppError({required this.message, this.statusCode, this.errorCode});

  // Predefined static instances of common application errors for easy reuse throughout the app.
  static const AppError unknown = AppError(
    message: 'An unexpected error occurred.',
    errorCode: 'UNKNOWN',
  );

  static const AppError noInternet = AppError(
    message: 'No internet connection.',
    statusCode: 0,
    errorCode: 'NO_INTERNET',
  );

  static const AppError timeout = AppError(
    message: 'Request timed out. Please try again.',
    statusCode: 408,
    errorCode: 'TIMEOUT',
  );

  static const AppError unauthorized = AppError(
    message: 'Session expired. Please log in again.',
    statusCode: 401,
    errorCode: 'UNAUTHORIZED',
  );

  // Creates the matching error for an HTTP [statusCode]. [message] replaces the default text, except for 408, which always uses [timeout].
  factory AppError.fromStatusCode(int statusCode, {String? message}) {
    switch (statusCode) {
      case 400:
        return AppError(
          message: message ?? 'Invalid request.',
          statusCode: 400,
          errorCode: 'BAD_REQUEST',
        );
      case 401:
        return AppError(
          message: message ?? 'Unauthorized.',
          statusCode: 401,
          errorCode: 'UNAUTHORIZED',
        );
      case 403:
        return AppError(
          message: message ?? 'Access denied.',
          statusCode: 403,
          errorCode: 'FORBIDDEN',
        );
      case 404:
        return AppError(
          message: message ?? 'Resource not found.',
          statusCode: 404,
          errorCode: 'NOT_FOUND',
        );
      case 408:
        return AppError.timeout;
      case 422:
        return AppError(
          message: message ?? 'Validation failed.',
          statusCode: 422,
          errorCode: 'VALIDATION',
        );
      case 500:
        return AppError(
          message: message ?? 'Server error.',
          statusCode: 500,
          errorCode: 'SERVER_ERROR',
        );
      default:
        return AppError(
          message: message ?? 'Request failed.',
          statusCode: statusCode,
          errorCode: 'HTTP_$statusCode',
        );
    }
  }

  // Convenience getters to check the type of error based on the error code.
  bool get isUnauthorized => errorCode == 'UNAUTHORIZED';
  bool get isNoInternet => errorCode == 'NO_INTERNET';
  bool get isTimeout => errorCode == 'TIMEOUT';

  // Method to create a copy of the current AppError instance with optional new values for its properties.
  AppError copyWith({String? message, int? statusCode, String? errorCode}) {
    return AppError(
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  // Override the toString method to provide a string representation of the AppError instance, including its properties.
  @override
  String toString() =>
      'AppError(code: $errorCode, status: $statusCode, message: $message)';
}
