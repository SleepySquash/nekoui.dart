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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/router.dart';
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
                    label: Text(
                      '${c.cart.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    alignment: AlignmentDirectional.topEnd,
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
                        isLabelVisible: c.cart.where((m) => m == e).isNotEmpty,
                        alignment: AlignmentDirectional.topEnd,
                        label: Text(
                          '${c.cart.firstWhereOrNull((m) => m == e)?.count}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: SizedBox(
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
