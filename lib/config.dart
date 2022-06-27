import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:toml/toml.dart';

/// Configuration of this application.
class Config {
  /// Sentry DSN (Data Source Name) to send errors to.
  ///
  /// If empty, then omitted.
  static late String sentryDsn;

  static late String openWeatherKey;

  /// Initializes this [Config] by applying values from the following sources
  /// (in the following order):
  /// - default values;
  /// - compile-time environment variables;
  /// - bundled configuration file (`conf.toml`).
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    Map<String, dynamic> document =
        TomlDocument.parse(await rootBundle.loadString('assets/conf.toml'))
            .toMap();

    sentryDsn = const bool.hasEnvironment('NEKOUI_SENTRY_DSN')
        ? const String.fromEnvironment('NEKOUI_SENTRY_DSN')
        : (document['sentry']?['dsn'] ?? '');

    openWeatherKey = const bool.hasEnvironment('NEKOUI_OPEN_WEATHER_KEY')
        ? const String.fromEnvironment('NEKOUI_OPEN_WEATHER_KEY')
        : (document['openweather']?['key'] ?? '');
  }
}
