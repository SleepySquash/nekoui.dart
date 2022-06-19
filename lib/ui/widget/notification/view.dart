import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/domain/service/notification.dart';
import 'controller.dart';

class NotificationOverlayView extends StatelessWidget {
  const NotificationOverlayView({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NotificationOverlayController(
        Get.find(),
        builder: (context, e, animation) => _notification(e, animation),
      ),
      builder: (NotificationOverlayController c) {
        return SafeArea(
          child: Stack(
            children: [
              child,
              IgnorePointer(
                child: Obx(() {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                    child: AnimatedList(
                      key: c.listKey,
                      shrinkWrap: true,
                      initialItemCount: c.notifications.length,
                      itemBuilder: (context, i, animation) {
                        return _notification(c.notifications[i], animation);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _notification(LocalNotification item, Animation<double> animation) {
    return Align(
      alignment: Alignment.topRight,
      child: SlideTransition(
        position:
            Tween(begin: const Offset(1, 0), end: const Offset(0, 0)).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.linearToEaseOut,
          ),
        ),
        child: Card(
          margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.icon != null) Icon(item.icon),
                      if (item.title != null) Text(item.title!),
                    ],
                  ),
                  if (item.text != null) Text(item.text!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
