import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/events.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:nekoui/util/flame.dart';

class NekoComponent extends SpriteComponent
    with HasGameRef, Tappable, CollisionCallbacks {
  NekoComponent({this.onTap});

  final void Function()? onTap;

  Vector2? _previous;
  Vector2? _moveTo;
  Timer? _standing;

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('neko/chibi.png');
    anchor = Anchor.center;
    size = sprite!.originalSize.height(200);

    position = Vector2(0, 0);
    _previous = Vector2(position.x, position.y);

    _standing = Timer(const Duration(milliseconds: 600), _move);

    add(
      RectangleHitbox.relative(
        Vector2(0.35, 1),
        parentSize: size,
        isSolid: true,
      ),
    );

    await super.onLoad();
  }

  @override
  void update(double dt) {
    if (_standing == null) {
      bool x = false, y = false;

      Vector2 next = position;

      if (next.x < _moveTo!.x - 50) {
        next = Vector2(next.x + 200 * dt, next.y);
      } else if (next.x > _moveTo!.x + 50) {
        next = Vector2(next.x - 200 * dt, next.y);
      } else {
        x = true;
      }

      if (next.y < _moveTo!.y - 50) {
        next = Vector2(next.x, next.y + 200 * dt);
      } else if (next.y > _moveTo!.y + 50) {
        next = Vector2(next.x, next.y - 200 * dt);
      } else {
        y = true;
      }

      if (x && y) {
        _standing = Timer(const Duration(milliseconds: 1200), _move);
      } else {
        if (!isColliding) {
          _previous = Vector2(position.x, position.y);
          position = next;
        } else {
          position = _previous ?? position;
          _standing = Timer(const Duration(milliseconds: 16), _move);
        }
      }
    }
    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    onTap?.call();
    return super.onTapUp(info);
  }

  void _move() {
    _standing?.cancel();
    _standing = null;
    _moveTo = Vector2(
      (-600 + Random().nextInt(1200)).toDouble(),
      (-600 + Random().nextInt(1200)).toDouble(),
    );
  }
}

class NekoComponent2 extends RiveComponent with HasGameRef {
  NekoComponent2({required super.artboard});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;
    size = Vector2(artboard.width, artboard.height).height(230);

    artboard
        .addController(StateMachineController(artboard.stateMachines.first));
  }
}
