import 'package:get/get.dart';

import '/domain/model/item.dart';
import '/domain/model/neko.dart';
import '/domain/service/item.dart';
import '/domain/service/neko.dart';
import '/util/obs/obs.dart';

class InventoryController extends GetxController {
  InventoryController(this._itemService, this._nekoService);

  final RxBool isDragging = RxBool(false);

  final ItemService _itemService;
  final NekoService _nekoService;

  bool _draggingIsLocked = false;

  Rx<Neko?> get neko => _nekoService.neko;

  RxObsMap<String, Item> get items => _itemService.items;

  void use(Item item) {
    if (item is Consumable) {
      if (_nekoService.give(item)) {
        _itemService.remove(item, 1);
      }
    }
  }

  void lockDragging() => _draggingIsLocked = true;
  void setDragging(bool value) {
    if (!_draggingIsLocked) {
      isDragging.value = value;
    }
  }
}
