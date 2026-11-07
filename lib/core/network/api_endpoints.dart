import '../core.dart';

/// This class defines the API endpoints used in the application. It provides a centralized location for managing API URLs, making it easier to update and maintain them. The endpoints are constructed using the base URL defined in the environment configuration, ensuring that they adapt to different environments (e.g., development, staging, production) without requiring changes to the codebase.
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();
  // Returns the base URL for the API based on the current environment.
  static String get baseUrl => EnvConfig.baseUrl;
  // Returns the endpoint
  static String get refreshToken => '$baseUrl/auth/refresh';
  static String get loginEndpoint => '$baseUrl/auth/login';
  static String get logoutEndpoint => '$baseUrl/auth/logout';
}