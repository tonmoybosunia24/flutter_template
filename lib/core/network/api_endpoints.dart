import '../core.dart';

/// Central list of API URLs, built from the base URL of the current environment in [EnvConfig].
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();
  // Returns the base URL for the API based on the current environment.
  static String get baseUrl => EnvConfig.baseUrl;
  // Auth endpoints
  static String get refreshToken => '$baseUrl/auth/refresh';
  static String get loginEndpoint => '$baseUrl/auth/login';
  static String get logoutEndpoint => '$baseUrl/auth/logout';
  // Post endpoints
  static String get posts => '$baseUrl/posts';
  static String get postsNewestFirst => '$posts?_sort=created_at&_order=desc';
}