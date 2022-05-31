import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/util/web/web_utils.dart';

// TODO: Remove when jonataslaw/getx#1936 is fixed:
//       https://github.com/jonataslaw/getx/issues/1936
/// [GetPlatform] adapter that fixes incorrect [GetPlatform.isMacOS] detection.
class PlatformUtils {
  /// Indicates whether application is running in a web browser.
  static bool get isWeb => GetPlatform.isWeb;

  /// Indicates whether device's OS is macOS.
  static bool get isMacOS => WebUtils.isMacOS || GetPlatform.isMacOS;

  /// Indicates whether device's OS is Windows.
  static bool get isWindows => GetPlatform.isWindows;

  /// Indicates whether device's OS is Linux.
  static bool get isLinux => GetPlatform.isLinux;

  /// Indicates whether device's OS is Android.
  static bool get isAndroid => GetPlatform.isAndroid;

  /// Indicates whether device's OS is iOS.
  static bool get isIOS => GetPlatform.isIOS;

  /// Indicates whether device is running on a mobile OS.
  static bool get isMobile => GetPlatform.isIOS || GetPlatform.isAndroid;

  /// Indicates whether device is running on a desktop OS.
  static bool get isDesktop =>
      PlatformUtils.isMacOS || GetPlatform.isWindows || GetPlatform.isLinux;
}

/// Determining whether a [BuildContext] is mobile or not.
extension MobileExtensionOnContext on BuildContext {
  /// Returns `true` if [MediaQuery]'s width is less than `600p` on desktop and
  /// [MediaQuery]'s shortest side is less than `600p` on mobile.
  bool get isMobile => PlatformUtils.isDesktop
      ? MediaQuery.of(this).size.width < 600
      : MediaQuery.of(this).size.shortestSide < 600;
}
