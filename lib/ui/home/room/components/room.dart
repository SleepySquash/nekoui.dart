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

import '../controller.dart';

class RoomWidget extends StatelessWidget {
  RoomWidget(this.c, {Key? key}) : super(key: key);

  final RoomController c;

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

            return Tile(100.0 * i, 100.0 * j, asset);
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
    double width = 0;
    double height = 0;

    final List<Transform2D> tiles = [...floor, ...furniture];

    for (var e in tiles) {
      if (e.position.dx + e.size.width > width) {
        width = e.position.dx + e.size.width;
      }

      if (e.position.dy + e.size.height > height) {
        height = e.position.dy + e.size.height;
      }
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: tiles.map(
          (e) {
            return Positioned(
              left: e.position.dx,
              top: e.position.dy,
              width: e.size.width,
              height: e.size.height,
              child: e.build(context),
            );
          },
        ).toList(),
      ),
    );
  }
}

abstract class Drawable {
  Widget build(BuildContext context);
}

mixin Transform2D on Drawable {
  Offset get position => const Offset(0, 0);
  Size get size => const Size(0, 0);
}

class Tile extends Drawable with Transform2D {
  Tile(
    double x,
    double y,
    this.asset, {
    this.size = const Size(100, 100),
  }) : position = Offset(x, y);

  final String asset;

  @override
  final Offset position;

  @override
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/location/$asset',
      fit: BoxFit.cover,
      isAntiAlias: true,
      filterQuality: FilterQuality.high,
    );
  }
}

class Entity extends Drawable with Transform2D {
  Entity(
    double x,
    double y,
    this.asset, {
    this.size = const Size(100, 100),
  }) : position = Offset(x, y);

  final String asset;

  @override
  final Offset position;

  @override
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/location/$asset',
      fit: BoxFit.fitHeight,
      isAntiAlias: false,
      filterQuality: FilterQuality.none,
    );
  }
}
