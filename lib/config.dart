// Copyright © 2022 NIKITA ISAENKO, <https://github.com/SleepySquash>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

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
