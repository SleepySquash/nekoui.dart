import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Node;
import 'package:nekoui/domain/model/thought.dart';
import 'package:nekoui/router.dart';
import 'package:rive/components.dart';
import 'package:rive/rive.dart';

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

    super.onInit();
  }

  @override
  void onClose() {
    _thoughtSubscription?.cancel();
    super.onClose();
  }
}
