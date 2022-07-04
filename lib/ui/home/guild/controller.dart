import 'package:get/get.dart';

import '/domain/model/item.dart';
import '/domain/model/neko.dart';
import '/domain/service/item.dart';
import '/domain/service/neko.dart';
import '/util/obs/obs.dart';

class GuildController extends GetxController {
  GuildController(this._nekoService);

  final NekoService _nekoService;

  Rx<Neko?> get neko => _nekoService.neko;
}
