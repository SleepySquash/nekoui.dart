// ignore_for_file: avoid_print

import 'dart:developer' as developer;
import 'dart:core' as core;

import '/util/platform_utils.dart';
import '/util/web/web_utils.dart';

// TODO: That's a temporary solution, we should use a proper logger.
class Log {
  /// Prints the provided [message] into the console.
  static void print(core.String message, [core.String? tag]) =>
      PlatformUtils.isWeb
          ? core.print('[$tag]: $message')
          : developer.log(message, name: tag ?? '');

  /// Prints the provided [object] into the console as an error.
  static void error(core.Object? object) =>
      PlatformUtils.isWeb ? WebUtils.consoleError(object) : core.print(object);
}
