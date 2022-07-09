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

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/domain/service/notification.dart';
import '/util/obs/obs.dart';

class NotificationOverlayController extends GetxController {
  NotificationOverlayController(
    this._notificationService, {
    required this.builder,
  });

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final NotificationService _notificationService;
  final Widget Function(BuildContext, LocalNotification, Animation<double>)
      builder;

  StreamSubscription? _notificationsSubscription;

  RxObsList<LocalNotification> get notifications =>
      _notificationService.notifications;

  @override
  void onInit() {
    _notificationsSubscription = notifications.changes.listen((e) {
      switch (e.op) {
        case OperationKind.added:
          listKey.currentState?.insertItem(e.pos);
          break;

        case OperationKind.removed:
          listKey.currentState?.removeItem(
            e.pos,
            (context, animation) => builder(context, e.element, animation),
          );
          break;

        case OperationKind.updated:
          // TODO: Handle this case.
          break;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    _notificationsSubscription?.cancel();
    super.onClose();
  }
}
