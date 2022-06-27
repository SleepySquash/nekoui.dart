import 'dart:async' show Timer;
import 'dart:math';

import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../disposable_service.dart';
import '/util/obs/obs.dart';
import '/util/platform_utils.dart';
import '/util/web/web_utils.dart';

/// Service responsible for notifications management.
class NotificationService extends DisposableService {
  final RxObsList<LocalNotification> notifications = RxObsList();

  static const Duration notificationDuration = Duration(seconds: 10);

  final List<Timer> _timers = [];

  /// Instance of a [FlutterLocalNotificationsPlugin] used to send notifications
  /// on non-web platforms.
  FlutterLocalNotificationsPlugin? _plugin;

  /// Initializes this [NotificationService].
  ///
  /// Requests permission to send notifications if it hasn't been granted yet.
  ///
  /// Optional [onNotificationResponse] callback is called when user taps on a
  /// notification.
  ///
  /// Optional [onDidReceiveLocalNotification] callback is called
  /// when a notification is triggered while the app is in the foreground and is
  /// only applicable to iOS versions older than 10.
  Future<void> init({
    void Function(NotificationResponse)? onNotificationResponse,
    void Function(int, String?, String?, String?)?
        onDidReceiveLocalNotification,
  }) async {
    if (PlatformUtils.isWeb) {
      // Permission request is happening in `index.html` via a script tag due to
      // a browser's policy to ask for notifications permission only after
      // user's interaction.
      WebUtils.onSelectNotification = onNotificationResponse;
    } else {
      if (_plugin == null) {
        tz.initializeTimeZones();

        _plugin = FlutterLocalNotificationsPlugin();
        await _plugin!.initialize(
          InitializationSettings(
            android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings(
              onDidReceiveLocalNotification: onDidReceiveLocalNotification,
            ),
            macOS: const DarwinInitializationSettings(),
            linux:
                const LinuxInitializationSettings(defaultActionName: 'click'),
          ),
          onDidReceiveNotificationResponse: onNotificationResponse,
          onDidReceiveBackgroundNotificationResponse: onNotificationResponse,
        );
      }
    }
  }

  // TODO: Implement icons and attachments on non-web platforms.
  /// Shows a notification with a [title] and an optional [body] and [icon].
  ///
  /// Use [payload] to embed information into the notification.
  Future<void> show(
    String title, {
    String? body,
    String? payload,
    String? icon,
  }) async {
    if (PlatformUtils.isWeb) {
      WebUtils.showNotification(
        title,
        body: body,
        lang: payload,
        icon: icon,
      ).onError((_, __) => false);
    } else {
      await _plugin!.show(
        Random().nextInt(1 << 31),
        title,
        body,
        const NotificationDetails(
          android:
              AndroidNotificationDetails('com.melancholyhill.nekoui', 'nekoui'),
        ),
        payload: payload,
      );
    }
  }

  Future<void> schedule(
    String title, {
    required Duration at,
    int id = 0,
    String? body,
    String? payload,
    String? icon,
  }) async {
    await _plugin!.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(at),
      const NotificationDetails(
        android:
            AndroidNotificationDetails('com.melancholyhill.nekoui', 'nekoui'),
      ),
      androidAllowWhileIdle: false,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancel(int id) => _plugin!.cancel(id);

  void notify(LocalNotification notification) {
    notifications.add(notification);

    Timer? timer;
    timer = Timer(notificationDuration, () {
      notifications.remove(notification);
      _timers.remove(timer);
    });

    _timers.add(timer);
  }
}

class LocalNotification {
  const LocalNotification({
    this.title,
    this.text,
    this.icon,
  });

  final String? title;
  final String? text;
  final IconData? icon;
}
