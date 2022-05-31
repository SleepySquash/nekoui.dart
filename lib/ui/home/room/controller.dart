import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nekoui/router.dart';

import '/domain/service/neko.dart';

class RoomController extends GetxController {
  RoomController(this._nekoService);

  NekoService _nekoService;

  final GlobalKey nekoKey = GlobalKey();

  late final RxDouble x;
  late final RxDouble y;

  @override
  void onInit() {
    x = RxDouble((router.context?.mediaQuerySize.width ?? 0) / 2);
    y = RxDouble((router.context?.mediaQuerySize.height ?? 0) / 2);

    super.onInit();
  }
}
