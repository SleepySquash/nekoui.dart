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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show NotificationResponse;
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:novel/novel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:universal_io/io.dart';

import 'config.dart';
import 'domain/service/auth.dart';
import 'domain/service/notification.dart';
import 'l10n/_l10n.dart';
import 'provider/hive/session.dart';
import 'pubspec.g.dart';
import 'router.dart';
import 'theme.dart';
import 'util/log.dart';
import 'util/platform_utils.dart';
import 'util/web/web_utils.dart';

/// Entry point of this application.
void main() async {
  await Config.init();

  // Initializes and runs the [App].
  Future<void> _appRunner() async {
    WebUtils.setPathUrlStrategy();

    Novel.backgrounds = 'assets/background';
    Novel.characters = 'assets/character';

    await _initHive();

    Get.put(NotificationService())
        .init(onNotificationResponse: onNotificationResponse);

    var authService = Get.put(AuthService(Get.find()));
    await authService.init();

    /// TODO: Should only be called if not persisted.
    var locale = Platform.localeName.replaceAll('-', '_');
    L10n.chosen = L10n.locales.containsKey(locale) ? locale : 'en_US';

    router = RouterState(authService);

    runApp(
      DefaultAssetBundle(
        bundle: SentryAssetBundle(),
        child: const App(),
      ),
    );
  }

  // No need to initialize the Sentry if no DSN is provided, otherwise useless
  // messages are printed to the console every time the application starts.
  if (Config.sentryDsn.isEmpty) {
    return _appRunner();
  }

  return SentryFlutter.init(
    (options) => {
      options.dsn = Config.sentryDsn,
      options.tracesSampleRate = 1.0,
      options.release = '${Pubspec.name}@${Pubspec.version}',
      options.debug = true,
      options.diagnosticLevel = SentryLevel.info,
      options.enablePrintBreadcrumbs = true,
      options.logger = (
        SentryLevel level,
        String message, {
        String? logger,
        Object? exception,
        StackTrace? stackTrace,
      }) {
        // `sentry.flutterError` are reported automatically in `kDebugMode`.
        if (exception != null &&
            (logger != 'sentry.flutterError' || !kDebugMode)) {
          StringBuffer buf = StringBuffer('$exception');
          if (stackTrace != null) {
            buf.write(
                '\n\nWhen the exception was thrown, this was the stack:\n');
            buf.write(stackTrace.toString().replaceAll('\n', '\t\n'));
          }

          Log.error(buf.toString());
        }
      },
    },
    appRunner: _appRunner,
  );
}

/// Callback, triggered when an user taps on a notification.
///
/// Must be a top level function.
void onNotificationResponse(NotificationResponse response) {
  if (response.payload != null) {}
}

/// Implementation of this application.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      routerDelegate: router.delegate,
      routeInformationParser: router.parser,
      routeInformationProvider: router.provider,
      navigatorObservers: [SentryNavigatorObserver()],
      onGenerateTitle: (context) => 'NekoUI',
      theme: Themes.light(),
      themeMode: ThemeMode.light,
      locale: L10n.locales[L10n.chosen],
      translationsKeys: L10n.phrases,
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Initializes a [Hive] storage and registers a [SessionDataHiveProvider] in
/// the [Get]'s context.
Future<void> _initHive() async {
  await Hive.initFlutter('hive');
  await Get.put(SessionHiveProvider()).init();
}

/// Extension adding an ability to clean [Hive].
extension HiveClean on HiveInterface {
  /// Cleans the [Hive] data stored at the provided [path] on non-web platforms
  /// and the whole `IndexedDB` on a web platform.
  Future<void> clean(String path) async {
    if (PlatformUtils.isWeb) {
      await WebUtils.cleanIndexedDb();
    } else {
      var documents = (await getApplicationDocumentsDirectory()).path;
      try {
        await Directory('$documents/$path').delete(recursive: true);
      } on FileSystemException {
        // No-op.
      }
    }
  }
}
