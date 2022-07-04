// ignore_for_file: avoid_print

import 'dart:core' as core;

class Log {
  static const core.String tag = 'NEKOUI';
  static core.bool enabled = true;

  static void print(core.String message) {
    if (enabled) core.print('[$tag] $message');
  }

  static void warn(core.String message) {
    if (enabled) core.print('[$tag][WARNING] $message');
  }

  static void error(core.String message) {
    if (enabled) core.print('[$tag][ERROR] $message');
  }
}
