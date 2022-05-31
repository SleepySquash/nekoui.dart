import 'package:flutter/widgets.dart';

/// Configuration of this application.
class Config {
  /// Sentry DSN (Data Source Name) to send errors to.
  ///
  /// If empty, then omitted.
  static late String sentryDsn;

  /// Initializes this [Config] by applying values from the following sources
  /// (in the following order):
  /// - default values;
  /// - compile-time environment variables;
  /// - bundled configuration file (`conf.toml`).
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    sentryDsn = const bool.hasEnvironment('SOCAPP_SENTRY_DSN')
        ? const String.fromEnvironment('SOCAPP_SENTRY_DSN')
        : '';
  }
}
