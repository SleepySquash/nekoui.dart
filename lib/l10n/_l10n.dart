import 'dart:ui';

import 'en_us.dart';
import 'ru_ru.dart';

/// Localization of this application.
abstract class L10n {
  /// Supported languages as locales with its names.
  static Map<String, String> languages = const {
    'en_US': 'English',
    'ru_RU': 'Русский',
  };

  /// Translated phrases for each supported locale.
  static Map<String, Map<String, String>> phrases = {
    'en_US': enUS,
    'ru_RU': ruRU,
  };

  // TODO: Make it reactive.
  // TODO: Should be persisted in storage.
  /// Currently selected locale.
  static String chosen = 'ru_RU';

  /// Supported locales.
  static Map<String, Locale> locales = const {
    'en_US': Locale('en', 'US'),
    'ru_RU': Locale('ru', 'RU'),
  };
}
