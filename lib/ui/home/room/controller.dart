import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/domain/model/neko.dart';
import '/domain/service/neko.dart';
import '/router.dart';
import '/ui/home/flowchart/view.dart';
import '/ui/home/inventory/view.dart';
import '/ui/home/map/view.dart';
import '/ui/home/neko/view.dart';

class RoomController extends GetxController {
  RoomController(this._neko);

  final NekoService _neko;

  final GlobalKey nekoKey = GlobalKey();
  final GlobalKey<CircularMenuState> fabKey = GlobalKey();

  late final RxDouble x;
  late final RxDouble y;

  Rx<Neko?> get neko => _neko.neko;

  @override
  void onInit() {
    x = RxDouble((router.context?.mediaQuerySize.width ?? 0) / 2);
    y = RxDouble((router.context?.mediaQuerySize.height ?? 0) / 2);

    super.onInit();
  }
}
