import 'package:get/get.dart';

import '/domain/model/item.dart';
import '/domain/service/item.dart';

class GroceryController extends GetxController {
  GroceryController(this._itemService);

  final RxList<Item> cart = RxList();
  late final List<Item> items;

  final ItemService _itemService;

  @override
  void onInit() {
    items = [
      CupcakeItem(1),
      DonutItem(1),
      IcecreamItem(1),
      CakeItem(1),
      WaterBottleItem(1),
    ];

    super.onInit();
  }

  void add(Item item) {
    var index = cart.indexWhere((e) => e == item);
    if (index == -1) {
      cart.add(item);
    } else {
      cart[index].count.value++;
    }
  }

  void remove(Item item) {
    var index = cart.indexWhere((e) => e == item);
    if (index != -1) {
      cart[index].count.value--;
      if (cart[index].count <= 0) {
        cart.removeAt(index);
      }
    }
  }

  void buy() {
    for (var i in cart) {
      _itemService.add(i);
    }
    cart.clear();
  }
}
