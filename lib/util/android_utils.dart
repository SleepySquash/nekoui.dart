import 'package:flutter/services.dart';

/// Helper providing direct access to Android-only features.
class AndroidUtils {
  /// [MethodChannel] to communicate with Android via.
  static const platform =
      MethodChannel('instrumentisto.flutter.dev/android_utils');

  /// Indicates whether this device has a permission to draw overlays.
  static Future<bool> canDrawOverlays() async {
    return await platform.invokeMethod('canDrawOverlays');
  }

  /// Opens overlay settings of this device.
  static Future<void> openOverlaySettings() async {
    await platform.invokeMethod('openOverlaySettings');
  }

  /// Requests this device to open this activity from a lockscreen.
  static Future<void> foregroundFromLockscreen() async {
    await platform.invokeMethod('foregroundFromLockscreen');
  }
}
