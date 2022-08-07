import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class NpcController extends GetxController {
  NpcController({
    required Offset position,
    required Size size,
  })  : position = Rx(position),
        _previousPosition = position,
        size = Rx(size);

  final Rx<Offset> position;
  final Rx<Size> size;

  Offset _previousPosition;
  Duration _deltaTime = Duration.zero;
  Offset? _moveTo;
  Timer? _timer;

  bool _alive = true;

  @override
  void onInit() {
    _timer =
        Timer(Duration(milliseconds: Random().nextInt(5000)), _generateMove);
    super.onInit();
  }

  @override
  void onClose() {
    _alive = false;
    _timer?.cancel();
    super.onClose();
  }

  void _generateMove() {
    _previousPosition = position.value;
    _moveTo = Offset(
      1024 + Random().nextDouble() * 16 * 100,
      1024 + Random().nextDouble() * 8 * 100,
    );

    SchedulerBinding.instance.addPostFrameCallback(_delta);
  }

  void _delta(Duration duration) {
    if (!_alive) return;

    Duration delta = duration - _deltaTime;
    _deltaTime = duration;

    if (_moveTo != null) {
      position.value = Offset.lerp(position.value, _moveTo, 0.01)!;

      if (position.value.dx >= _moveTo!.dx - 5 &&
          position.value.dx <= _moveTo!.dx + 5 &&
          position.value.dy >= _moveTo!.dy - 5 &&
          position.value.dy <= _moveTo!.dy + 5) {
        _moveTo = null;
        _timer = Timer(
          Duration(milliseconds: Random().nextInt(5000)),
          _generateMove,
        );
      } else {
        SchedulerBinding.instance.addPostFrameCallback(_delta);
      }
    }
  }
}
