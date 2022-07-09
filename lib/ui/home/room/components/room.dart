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

import '../controller.dart';

class RoomWidget extends StatelessWidget {
  RoomWidget(this.c, {Key? key}) : super(key: key);

  final RoomController c;

  final List<Tile> tiles = [
    Tile(0, 0, 32, 32, 'floor/wooden.jpeg'),
    Tile(32, 32, 32, 32, 'floor/wooden.jpeg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: tiles
          .map(
            (e) => Positioned(
              left: e.x,
              top: e.y,
              width: e.width,
              height: e.height,
              child: Image.asset(
                'assets/room/${e.asset}',
                fit: BoxFit.cover,
              ),
            ),
          )
          .toList(),
    );
  }
}

class Tile {
  Tile(this.x, this.y, this.width, this.height, this.asset);

  final double x;
  final double y;
  final double width;
  final double height;
  final String asset;
}
