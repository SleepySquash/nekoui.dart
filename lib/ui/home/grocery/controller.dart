import 'package:flutter/widgets.dart' show BuildContext;
import 'package:get/get.dart';

import '/domain/model/item.dart';
import '/domain/service/item.dart';
import '/ui/home/map/view.dart';

class GroceryController extends GetxController {
  GroceryController(this._itemService);

  final RxList<Item> cart = RxList();
  late final List<Item> items;

  final ItemService _itemService;

  Future showMap(BuildContext context) => MapView.show(context: context);

  @override
  void onInit() {
    items = [
      CupcakeItem(1.obs),
      WaterBottleItem(1.obs),
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
