enum Environment { dev, staging, prod }

/// A class that provides access to environment-specific configuration values.
class EnvConfig {

  // Private constructor to prevent instantiation.
  EnvConfig._();

  /// The name of the environment, which can be set via the `ENV` environment variable.
  static const String _envName = String.fromEnvironment('ENV', defaultValue: 'dev');

  /// The base URL for the API, which can be overridden via the `API_BASE_URL` environment variable.
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  /// Returns the current environment based on the `_envName` value.
  static Environment get environment => switch (_envName) {
    'prod' => Environment.prod,
    'staging' => Environment.staging,
    _ => Environment.dev,
  };

  // Returns the base URL for the API based on the current environment.
  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) return _baseUrlOverride;

    return switch (environment) {
      // TODO: Replace these with your own API hosts.
      Environment.dev => 'https://dev.api.example.com',
      Environment.staging => 'https://staging.api.example.com',
      Environment.prod => 'https://api.example.com',
    };
  }

  // Returns true if the current environment is development.
  static bool get isDev => environment == Environment.dev;

  // Returns true if the current environment is production.
  static bool get isProd => environment == Environment.prod;
}
