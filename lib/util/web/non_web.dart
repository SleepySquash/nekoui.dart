import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show NotificationResponse;

/// Helper providing direct access to browser-only features.
///
/// Does nothing on desktop or mobile.
class WebUtils {
  /// Callback, called when user taps onto a notification.
  static void Function(NotificationResponse)? onSelectNotification;

  /// Indicates whether device's OS is macOS or iOS.
  static bool get isMacOS => false;

  /// Indicates whether device's browser is in fullscreen mode or not.
  static bool get isFullscreen => false;

  /// Pushes [title] to browser's window title.
  static void title(String title) {
    // No-op.
  }

  /// Sets the URL strategy of your web app to using paths instead of a leading
  /// hash (`#`).
  static void setPathUrlStrategy() {
    // No-op.
  }

  /// Shows a notification via "Notification API" of the browser.
  static Future<void> showNotification(
    String title, {
    String? dir,
    String? body,
    String? lang,
    String? tag,
    String? icon,
  }) async {
    // No-op.
  }

  /// Does nothing as `IndexedDB` is absent on desktop or mobile platforms.
  static Future<void> cleanIndexedDb() async {
    // No-op.
  }

  /// Prints a string representation of the provided [object] to the console as
  /// an error.
  static void consoleError(Object? object) {
    // No-op.
  }
}
