// ignore_for_file: avoid_web_libraries_in_flutter

/// Helper providing direct access to browser-only features.
@JS()
library web_utils;

import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show NotificationResponse, NotificationResponseType;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';

import '../platform_utils.dart';

html.Navigator _navigator = html.window.navigator;

@JS('indexedDB.databases')
external databases();

@JS('indexedDB.deleteDatabase')
external deleteDatabase(String name);

/// Helper providing direct access to browser-only features.
///
/// Does nothing on desktop or mobile.
class WebUtils {
  /// Callback, called when user taps on a notification.
  static void Function(NotificationResponse)? onSelectNotification;

  /// Indicates whether device's OS is macOS or iOS.
  static bool get isMacOS =>
      _navigator.appVersion.contains('Mac') && !PlatformUtils.isIOS;

  /// Pushes [title] to browser's window title.
  static void title(String title) =>
      SystemChrome.setApplicationSwitcherDescription(
          ApplicationSwitcherDescription(label: title));

  /// Sets the URL strategy of your web app to using paths instead of a leading
  /// hash (`#`).
  static void setPathUrlStrategy() {
    if (urlStrategy is! PathUrlStrategy) {
      setUrlStrategy(PathUrlStrategy());
    }
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
    var notification = html.Notification(
      title,
      dir: dir,
      body: body,
      lang: lang,
      tag: tag,
      icon: icon,
    );

    notification.onClick.listen((event) {
      onSelectNotification?.call(NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
        payload: notification.lang,
      ));
      notification.close();
    });
  }

  /// Clears the browser's `IndexedDB`.
  static Future<void> cleanIndexedDb() async {
    var qs = await promiseToFuture(databases());
    for (int i = 0; i < qs.length; i++) {
      deleteDatabase(qs[i].name);
    }
  }

  /// Prints a string representation of the provided [object] to the console as
  /// an error.
  static void consoleError(Object? object) => html.window.console.error(object);
}
