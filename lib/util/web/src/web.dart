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

import '/util/platform_utils.dart';

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
