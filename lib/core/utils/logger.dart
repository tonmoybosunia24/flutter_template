import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Prints log messages in debug builds only. Release builds log nothing.
class AppLogger {
  // Private constructor to prevent instantiation
  AppLogger._();

  // The singleton instance of the logger.
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  // Logs an informational message.
  static void logInfo(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  // Logs an error message along with optional error details and stack trace.
  static void logError(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  // Logs a warning message.
  static void logWarning(String message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  // Logs a debug message.
  static void logDebug(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }
}
