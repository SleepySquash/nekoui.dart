import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('Idle1');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPerson) {
      return Image.asset(
        'assets/images/neko/${widget.isPerson ? 'person' : 'chibi'}.png',
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
      );
    } else {
      return RiveAnimation.asset(
        'assets/rive/chibi.riv',
        controllers: [_controller],
        onInit: (_) => setState(() {}),
      );
    }
  }
}
