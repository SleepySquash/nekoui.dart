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
