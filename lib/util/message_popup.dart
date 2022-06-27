import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/router.dart';
import 'localized_exception.dart';

/// Helper to display a popup message in UI.
class MessagePopup {
  /// Shows an error popup with the provided argument.
  static Future<void> error(dynamic e) async {
    var message = e is LocalizedExceptionMixin ? e.toMessage() : e.toString();
    await showDialog(
      context: router.context!,
      builder: (context) => AlertDialog(
        title: Text('label_error'.tr),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(router.context!).pop(),
            child: Text('btn_ok'.tr),
          )
        ],
      ),
    );
  }

  static Future<void> message(String title, {String? description}) async {
    return showDialog(
      context: router.context!,
      builder: (context) => AlertDialog(
        key: const Key('AlertDialog'),
        title: Text(title),
        content: description == null ? null : Text(description),
        actions: [
          TextButton(
            key: const Key('AlertNoButton'),
            child: Text('btn_ok'.tr),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Shows an alert popup with [title], [description] and `yes`/`no` buttons
  /// that returns `true`, `false` or `null` based on the button that was
  /// pressed.
  static Future<bool?> alert(String title, {String? description}) => showDialog(
        context: router.context!,
        builder: (context) => AlertDialog(
          key: const Key('AlertDialog'),
          title: Text(title),
          content: description == null ? null : Text(description),
          actions: [
            TextButton(
              key: const Key('AlertNoButton'),
              child: Text('label_are_you_sure_no'.tr),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              key: const Key('AlertYesButton'),
              child: Text('label_are_you_sure_yes'.tr),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

  /// Shows a [SnackBar] with the [title] message.
  static void success(String title) =>
      ScaffoldMessenger.of(router.context!).showSnackBar(
        SnackBar(
          content: Text(title),
          width: 250,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
}
