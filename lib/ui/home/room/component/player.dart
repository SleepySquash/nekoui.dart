import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart'
    show LogicalKeyboardKey, RawKeyEvent, RawKeyDownEvent;

import '/util/flame.dart';

class PlayerComponent extends SpriteComponent
    with HasGameRef, KeyboardHandler, CollisionCallbacks {
  PlayerComponent() : super(anchor: Anchor.center);

  static const int speed = 300;

  bool moveA = false;
  bool moveD = false;
  bool moveW = false;
  bool moveS = false;

  Vector2? _previous;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('neko/chibi.png');
    size = sprite!.originalSize.height(200);
    anchor = Anchor.center;

    _previous = Vector2(position.x, position.y);

    add(RectangleHitbox(isSolid: true));
  }

  @override
  void update(double dt) {
    if (moveA || moveW || moveD || moveS) {
      Vector2 next = Vector2(position.x, position.y);

      if (moveA) {
        next.x -= speed * dt;
      } else if (moveD) {
        next.x += speed * dt;
      }

      if (moveW) {
        next.y -= speed * dt;
      } else if (moveS) {
        next.y += speed * dt;
      }

      // TODO: Fix laggy jumping when colliding.
      if (isColliding) {
        position = Vector2(_previous!.x, _previous!.y);
      } else {
        _previous = Vector2(position.x, position.y);
        position = Vector2(next.x, next.y);
      }
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      moveA = event is RawKeyDownEvent;
      return false;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      moveD = event is RawKeyDownEvent;
      return false;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      moveW = event is RawKeyDownEvent;
      return false;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      moveS = event is RawKeyDownEvent;
      return false;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
