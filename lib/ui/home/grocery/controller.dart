// Copyright © 2022 NIKITA ISAENKO, <https://github.com/SleepySquash>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

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
