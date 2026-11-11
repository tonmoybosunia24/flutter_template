/// The environments the app can be built for, selected with `--dart-define=ENV=<name>`.
enum Environment { dev, staging, prod }

/// Environment-specific configuration values, read from `--dart-define` at build time.
class EnvConfig {
  // Private constructor to prevent instantiation.
  EnvConfig._();

  // The environment name, set with `--dart-define=ENV=<name>`. Defaults to dev.
  static const String _envName = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  // Overrides the base URL of every environment when `--dart-define=API_BASE_URL=<url>` is set.
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  // The current environment. Any unknown name falls back to dev.
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
      Environment.dev => 'https://mock-server-iota-ebon.vercel.app',
      Environment.staging => 'https://mock-server-iota-ebon.vercel.app',
      Environment.prod => 'https://api.example.com',
    };
  }

  // Returns true if the current environment is development.
  static bool get isDev => environment == Environment.dev;

  // Returns true if the current environment is production.
  static bool get isProd => environment == Environment.prod;
}
