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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/l10n/l10n.dart';
import '/router.dart';

/// Helper to display a popup message in UI.
class MessagePopup {
  /// Shows an error popup with the provided argument.
  static Future<void> error(dynamic e) async {
    await showDialog(
      context: router.context!,
      builder: (context) => AlertDialog(
        title: Text('label_error'.l10n),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(router.context!).pop(),
            child: Text('btn_ok'.l10n),
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
            child: Text('btn_ok'.l10n),
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
              child: Text('label_are_you_sure_no'.l10n),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              key: const Key('AlertYesButton'),
              child: Text('label_are_you_sure_yes'.l10n),
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
