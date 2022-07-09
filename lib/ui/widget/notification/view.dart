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
