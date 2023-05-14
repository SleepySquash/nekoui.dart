import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart' show Rect;

import 'component/neko.dart';
import 'component/player.dart';
import 'component/room.dart';

class RoomGame extends FlameGame
    with
        ScrollDetector,
        PanDetector,
        ScaleDetector,
        HasTappables,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  RoomGame({this.displayNeko}) {
    debugMode = true;
  }

  final void Function(Rect)? displayNeko;

  static const _zoomPerScrollUnit = 0.02;

  late NekoComponent _neko;
  late RoomComponent _room;

  late double _startZoom;
  Vector2? _previousScale;

  /// Indicates whether [camera] is following the [_neko].
  bool get following => camera.follow == _neko.position;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.setRelativeOffset(Anchor.center);

    add(_room = RoomComponent());
    add(_neko = NekoComponent(
      onTap: () {
        if (following) {
          final topLeft = camera.worldToScreen(_neko.absoluteTopLeftPosition);
          final bottomRight = camera.worldToScreen(
            _neko.absoluteTopLeftPosition + _neko.absoluteScaledSize,
          );

          displayNeko?.call(
            Rect.fromLTRB(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y),
          );
        } else {
          camera.followComponent(_neko);

          // Starts following the component, if wasn't before.
          camera.resetMovement();
        }
      },
    ));

    // add(PlayerComponent());

    add(FpsComponent());
    add(FpsTextComponent());

    camera.followComponent(_neko);

    // add(
    //   NekoComponent2(
    //     artboard: await loadArtboard(RiveFile.asset('assets/rive/chibi1.riv')),
    //   ),
    // );
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (camera.follow != null) {
      // Set the delta to the current following position.
      camera.moveTo(camera.position);
      camera.follow = null;
    }

    camera.translateBy(-info.delta.game);
    camera.snap();

    super.onPanUpdate(info);
  }

  void clampZoom() => camera.zoom = camera.zoom.clamp(0.05, 3.0);

  @override
  void onScroll(PointerScrollInfo info) {
    camera.zoom += info.scrollDelta.game.y.sign * _zoomPerScrollUnit;
    clampZoom();
  }

  @override
  void onScaleStart(ScaleStartInfo info) => _startZoom = camera.zoom;

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final Vector2 currentScale = info.scale.global;

    if (currentScale != _previousScale) {
      _previousScale = currentScale;
      if (!currentScale.isIdentity()) {
        camera.zoom = _startZoom * currentScale.y;
        clampZoom();
      } else {
        camera.translateBy(-info.delta.game);
        camera.snap();
      }
    }
  }
}
