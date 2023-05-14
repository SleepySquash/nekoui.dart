import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:nekoui/util/flame.dart';

import 'furniture.dart';

// TODO: Refactor into [World].
class RoomComponent extends SpriteComponent with HasGameRef {
  final List<SpriteComponent> components = [];

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('room/room.png');
    size = sprite!.originalSize.height(1500);
    position = Vector2(0, 0);
    anchor = Anchor.center;

    // final atlas = await gameRef.loadSprite('atlas/srw_interior.png');
    // final atlas = await FireAtlas.loadAsset('images/atlas/srw_interior.fa');

    add(
      PolygonHitbox(
        [
          Vector2(200, 450),
          Vector2(2100, 450),
          Vector2(2100, 900),
          Vector2(1950, 900),
          Vector2(1950, 1040),
          Vector2(1520, 1040),
          Vector2(1520, 900),
          Vector2(930, 900),
          Vector2(930, 1200),
          Vector2(500, 1200),
          Vector2(200, 1200),
          Vector2(200, 900),
        ],
        collisionType: CollisionType.passive,
      ),
    );

    components.addAll([
      // for (var x = 0; x < 12; ++x)
      //   SpriteComponent(
      //     sprite: atlas.getSprite('wall1'),
      //     scale: Vector2.all(3),
      //     position: Vector2(x * 48 * 3, -48 * 2 * 3),
      //     anchor: Anchor.topLeft,
      //   ),
      // for (var x = 0; x < 12; ++x)
      //   for (var y = 0; y < 12; ++y)
      //     SpriteComponent(
      //       sprite: atlas.getSprite('floor${2 + Random().nextInt(3)}'),
      //       scale: Vector2.all(3),
      //       position: Vector2(x * 48 * 3, y * 48 * 3),
      //       anchor: Anchor.topLeft,
      //     ),
      // SpriteComponent(
      //   sprite: atlas.getSprite('bed1'),
      //   scale: Vector2.all(3),
      //   position: Vector2(48 * 3 * 5, 0),
      //   anchor: Anchor.topLeft,
      // ),
      FurnitureComponent(
        texture: 'bed1',
        position: Vector2(270, 1180),
        centimeters: 245,
      ),
      FurnitureComponent(
        texture: 'fridge1',
        position: Vector2(1437, 605),
        scale: Vector2.all(1.15),
        centimeters: 280,
      ),
      FurnitureComponent(
        texture: 'bathtub1',
        position: Vector2(1820, 1040),
        centimeters: 130,
      ),
    ]);

    components.forEach(add);

    await super.onLoad();
  }
}
