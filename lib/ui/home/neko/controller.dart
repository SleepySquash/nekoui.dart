import 'package:get/get.dart';

import '/domain/model/neko.dart';
import '/domain/service/neko.dart';

enum NekoViewScreen {
  ask,
  talk,
  action,
  activity,
}

class NekoController extends GetxController {
  NekoController(this._nekoService);

  final NekoService _nekoService;

  Rx<Neko?> get neko => _nekoService.neko;
  String? get name => neko.value?.name.value ?? 'Неко';

  final Rx<NekoViewScreen?> screen = Rx(null);
}
