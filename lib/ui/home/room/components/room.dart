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

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:nekoui/ui/home/neko/view.dart';
import 'package:nekoui/ui/home/room/components/neko/view.dart';

import '../controller.dart';

class RoomWidget extends StatefulWidget {
  const RoomWidget(this.c, {Key? key}) : super(key: key);

  final RoomController c;

  @override
  State<RoomWidget> createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  // 16 x 8
  final List<Tile> floor = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
    [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
  ]
      .mapIndexed(
        (j, e) => e.mapIndexed(
          (i, m) {
            String? asset;
            if (m == 1) {
              asset = 'floor/wooden.jpeg';
            }

            if (asset == null) {
              return null;
            }

            return Tile(1024 + 100.0 * i, 1024 + 100.0 * j, asset);
          },
        ),
      )
      .expand((e) => e)
      .whereNotNull()
      .toList();

  final List<Entity> furniture = [
    Entity(
      1200,
      0,
      'furniture/fridge1.png',
      size: const Size(190, 230),
    )
  ];

  @override
  Widget build(BuildContext context) {
    // double width = 0;
    // double height = 0;

    final List<Widget> tiles = [
      ...floor,
      ...furniture,
      Npc(asset: 'Chocola'),
      Npc(asset: 'Azuki'),
      Npc(asset: 'Maple'),
    ];

    // for (var e in tiles) {
    //   if (e.position.value.dx + e.size.value.width > width) {
    //     width = e.position.value.dx + e.size.value.width;
    //   }

    //   if (e.position.value.dy + e.size.value.height > height) {
    //     height = e.position.value.dy + e.size.value.height;
    //   }
    // }

    return Stack(children: tiles);
  }
}

mixin Transform2D on Widget {
  Rx<Offset> get position => Rx(const Offset(0, 0));
  Rx<Size> get size => Rx(const Size(10, 10));
}

class Tile extends StatelessWidget with Transform2D {
  Tile(
    double x,
    double y,
    this.asset, {
    Key? key,
    Size size = const Size(100, 100),
  })  : position = Rx(Offset(x, y)),
        size = Rx(size),
        super(key: key);

  final String asset;

  @override
  final Rx<Offset> position;

  @override
  final Rx<Size> size;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Positioned(
        left: position.value.dx,
        top: position.value.dy,
        width: size.value.width,
        height: size.value.height,
        child: Image.asset(
          'assets/location/$asset',
          fit: BoxFit.cover,
          isAntiAlias: true,
          filterQuality: FilterQuality.high,
        ),
      );
    });

    return Image.asset(
      'assets/location/$asset',
      fit: BoxFit.cover,
      isAntiAlias: true,
      filterQuality: FilterQuality.high,
    );
  }
}

class Entity extends StatelessWidget with Transform2D {
  Entity(
    double x,
    double y,
    this.asset, {
    Key? key,
    Size size = const Size(100, 100),
  })  : position = Rx(Offset(x, y)),
        size = Rx(size),
        super(key: key);

  final String asset;

  @override
  final Rx<Offset> position;

  @override
  final Rx<Size> size;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Positioned(
        left: position.value.dx,
        top: position.value.dy,
        width: size.value.width,
        height: size.value.height,
        child: Image.asset(
          'assets/location/$asset',
          fit: BoxFit.cover,
          isAntiAlias: false,
          filterQuality: FilterQuality.none,
        ),
      );
    });

    return Image.asset(
      'assets/location/$asset',
      fit: BoxFit.contain,
      isAntiAlias: false,
      filterQuality: FilterQuality.none,
    );
  }
}
