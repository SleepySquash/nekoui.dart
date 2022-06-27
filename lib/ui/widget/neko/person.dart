import 'package:flutter/material.dart';

import '/domain/service/neko.dart';

class NekoPerson extends StatefulWidget {
  const NekoPerson(this._nekoService, {Key? key}) : super(key: key);

  final NekoService _nekoService;

  @override
  State<NekoPerson> createState() => _NekoPersonState();
}

class _NekoPersonState extends State<NekoPerson> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        Image.asset(
          'assets/images/neko/person.png',
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
  }
}
