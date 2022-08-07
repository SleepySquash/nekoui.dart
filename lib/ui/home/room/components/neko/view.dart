import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../room.dart';
import 'controller.dart';

class Npc extends StatefulWidget {
  Npc({
    Key? key,
    this.asset,
    this.position = const Offset(
      1024 + 16 * 100 / 2,
      1024 + 8 * 100 / 2,
    ),
    this.size = const Size(200, 200),
  }) : super(key: key);

  final String? asset;

  final Offset position;

  final Size size;

  @override
  State<Npc> createState() => _NpcState();
}

class _NpcState extends State<Npc> {
  /// Unique ID of this [Npc].
  final String id = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NpcController(
        position: widget.position,
        size: widget.size,
      ),
      tag: id,
      builder: (NpcController c) {
        return Obx(() {
          return Positioned(
            left: c.position.value.dx,
            top: c.position.value.dy,
            width: c.size.value.width,
            height: c.size.value.height,
            child: Image.asset(
              'assets/character/${widget.asset}.png',
              fit: BoxFit.contain,
              isAntiAlias: true,
              filterQuality: FilterQuality.high,
            ),
          );
        });

        return Image.asset(
          'assets/character/${widget.asset}.png',
          fit: BoxFit.contain,
          isAntiAlias: true,
          filterQuality: FilterQuality.high,
        );
      },
    );
  }
}
