import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nekoui/domain/service/environment.dart';

import '/domain/model/neko.dart';
import '/domain/service/neko.dart';
import '/router.dart';

class RoomController extends GetxController {
  RoomController(this._neko, this._environment);

  final NekoService _neko;
  final EnvironmentService _environment;

  final GlobalKey nekoKey = GlobalKey();
  final GlobalKey<CircularMenuState> fabKey = GlobalKey();

  final RxDouble roomTemperature = RxDouble(20);

  late final RxDouble x;
  late final RxDouble y;

  Rx<Neko?> get neko => _neko.neko;
  Rx<Weather?> get weather => _environment.weather;
  RxnDouble get temperature => _environment.temperature;

  bool get isFocused => router.routes.length == 1 && !_neko.hasAttention;

  @override
  void onInit() {
    x = RxDouble((router.context?.mediaQuerySize.width ?? 0) / 2);
    y = RxDouble((router.context?.mediaQuerySize.height ?? 0) / 2);

    super.onInit();
  }
}
