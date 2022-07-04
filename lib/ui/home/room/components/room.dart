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
