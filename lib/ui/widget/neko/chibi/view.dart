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
import 'package:get/get.dart' hide Node;
import 'package:rive/components.dart';
import 'package:rive/rive.dart';
import 'package:uuid/uuid.dart';

import 'controller.dart';

class NekoChibi extends StatelessWidget {
  const NekoChibi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NekoChibiController(Get.find()),
      tag: const Uuid().v4(),
      builder: (NekoChibiController c) {
        return Stack(
          children: [
            KeyedSubtree(
              key: c.key,
              child: RiveAnimation.asset(
                'assets/rive/chibi1.riv',
                controllers: [c.animation],
                onInit: (a) {
                  c.faceControl = a.component<Node>('FaceControl');
                },
              ),
            ),
            Obx(() {
              if (c.thought.value == null) {
                return Container();
              }

              return Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(
                  offset: const Offset(2, -5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.brown.shade200,
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(color: Colors.brown.shade500, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.8)),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(2, 3, 2, 2),
                    child: Text(
                      c.thought.value!.value,
                      style: const TextStyle(
                        fontSize: 5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

// ever(router.mousePosition, (Offset? offset) {
//   if (mounted && offset != null && faceControl != null) {
//     setState(() {
//       faceControl?.x = offset.dx;
//       faceControl?.y = offset.dy;
//     });
//   }
// });