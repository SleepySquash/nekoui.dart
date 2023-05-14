import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:nekoui/util/flame.dart';

class FurnitureComponent extends SpriteComponent with HasGameRef {
  FurnitureComponent({
    required this.texture,
    super.position,
    super.scale,
    this.centimeters = 200,
    super.anchor = Anchor.bottomCenter,
  });

  final String texture;
  final double centimeters;

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('furniture/$texture.png');
    size = sprite!.originalSize.height(centimeters);

    add(RectangleHitbox(isSolid: true, collisionType: CollisionType.passive));

    await super.onLoad();
  }
}
