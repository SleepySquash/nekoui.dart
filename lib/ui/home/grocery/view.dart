import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/router.dart';
import '/ui/home/map/view.dart';
import 'controller.dart';

class GroceryView extends StatelessWidget {
  const GroceryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: GroceryController(Get.find()),
      builder: (GroceryController c) {
        return Obx(() {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Grocery'),
              actions: [
                if (c.cart.isNotEmpty)
                  Badge(
                    badgeContent: Text(
                      '${c.cart.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    position: BadgePosition.topEnd(top: 0, end: 0),
                    child: IconButton(
                      onPressed: router.groceryCheckout,
                      icon: const Icon(Icons.shopping_bag),
                    ),
                  ),
              ],
            ),
            body: Wrap(
              children: c.items
                  .map(
                    (e) => InkWell(
                      onTap: () => c.add(e),
                      child: Badge(
                        showBadge: c.cart.where((m) => m == e).isNotEmpty,
                        position: BadgePosition.topEnd(top: 0, end: 0),
                        badgeContent: Text(
                          '${c.cart.firstWhereOrNull((m) => m == e)?.count}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Image.asset(e.asset),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: router.map,
              child: const Icon(Icons.map),
            ),
          );
        });
      },
    );
  }
}
