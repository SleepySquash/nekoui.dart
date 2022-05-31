import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nekoui/ui/home/neko/view.dart';

import '/domain/service/neko.dart';
import '/router.dart';
import '/ui/widget/neko.dart';
import 'controller.dart';

class RoomView extends StatelessWidget {
  const RoomView(this._neko, {Key? key}) : super(key: key);

  final NekoService _neko;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RoomController(_neko),
      builder: (RoomController c) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: InteractiveViewer(
            clipBehavior: Clip.none,
            minScale: 1,
            maxScale: 10,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/room/room.png',
                    isAntiAlias: false,
                    filterQuality: FilterQuality.none,
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => NekoView.show(
                      context: context,
                      view: NekoView(
                        _neko,
                        globalKey: c.nekoKey,
                      ),
                    ),
                    child: SizedBox(
                      height: 70,
                      child: NekoWidget(
                        _neko,
                        key: c.nekoKey,
                        isPerson: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
