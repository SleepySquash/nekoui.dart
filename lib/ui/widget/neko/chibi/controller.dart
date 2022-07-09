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
import 'package:get/get.dart' hide Node;
import 'package:rive/components.dart';
import 'package:rive/rive.dart';

import '/domain/model/thought.dart';
import '/domain/service/neko.dart';
import '/util/obs/obs.dart';

class NekoChibiController extends GetxController {
  NekoChibiController(this._nekoService);

  final GlobalKey key = GlobalKey();
  late final RiveAnimationController animation;
  Node? faceControl;

  final Rx<Thought?> thought = Rx<Thought?>(null);

  final NekoService _nekoService;

  StreamSubscription? _thoughtSubscription;

  @override
  void onInit() {
    animation = SimpleAnimation('Idle1');

    _thoughtSubscription = _nekoService.thoughts.changes.listen((e) {
      switch (e.op) {
        case OperationKind.added:
          thought.value = e.element;
          break;

        case OperationKind.removed:
          if (thought.value == e.element) {
            thought.value = null;
          }
          break;

        case OperationKind.updated:
          // No-op.
          break;
      }
    });

    DateTime now = DateTime.now();
    String greetings = '...';

    if (now.hour >= 23 || now.hour < 4) {
      greetings = 'Доброй ночки!';
    } else if (now.hour < 10) {
      greetings = 'Добрейшего утречка!!';
    } else if (now.hour < 17) {
      greetings = 'Добрый день!!';
    } else if (now.hour < 23) {
      greetings = 'Добрый вечер!!';
    }

    _nekoService.addThought(Thought(greetings));

    super.onInit();
  }

  @override
  void onClose() {
    _thoughtSubscription?.cancel();
    super.onClose();
  }
}
