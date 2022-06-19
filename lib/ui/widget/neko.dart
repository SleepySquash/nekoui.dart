import 'package:flutter/material.dart';
import 'package:rive/components.dart';
import 'package:rive/rive.dart';

import '/domain/service/neko.dart';

class NekoWidget extends StatefulWidget {
  const NekoWidget(
    this._nekoService, {
    Key? key,
    this.isPerson = true,
  }) : super(key: key);

  final bool isPerson;

  final NekoService _nekoService;

  @override
  State<NekoWidget> createState() => _NekoWidgetState();
}

class _NekoWidgetState extends State<NekoWidget> {
  late RiveAnimationController _controller;
  Node? faceControl;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('Idle1');
    // Worker? mousePositionWorker;
    // mousePositionWorker = ever(router.mousePosition, (Offset? offset) {
    //   if (mounted && offset != null && faceControl != null) {
    //     setState(() {
    //       faceControl?.x = offset.dx;
    //       faceControl?.y = offset.dy;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPerson) {
      return Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Image.asset(
            'assets/images/neko/${widget.isPerson ? 'person' : 'chibi'}.png',
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
            fit: BoxFit.fitHeight,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  print('mur');
                },
                child: const MouseRegion(
                  opaque: false,
                  cursor: SystemMouseCursors.grab,
                  hitTestBehavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    width: 140,
                    height: 100,
                  ),
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return RiveAnimation.asset(
        'assets/rive/chibi1.riv',
        controllers: [_controller],
        onInit: (a) {
          faceControl = a.component<Node>('FaceControl');
        },
      );
    }
  }
}
