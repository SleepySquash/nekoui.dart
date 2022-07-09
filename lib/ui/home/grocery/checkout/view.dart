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

import '/ui/widget/backdrop_button.dart';
import '../controller.dart';

class GroceryCheckoutView extends StatelessWidget {
  const GroceryCheckoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (GroceryController c) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Checkout'),
          ),
          body: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return c.cart.isEmpty
                      ? const Center(child: Text('Empty'))
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ...c.cart
                                  .map(
                                    (e) => ListTile(
                                      leading: Image.asset(e.asset),
                                      title: Text(e.id),
                                      trailing: Text('${e.count}'),
                                    ),
                                  )
                                  .toList(),
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                                thickness: 2,
                                height: 30,
                              ),
                              Text(
                                'Total amount is: ${c.cart.map((e) => e.count.value).fold(0, (int a, int b) => a + b)}',
                              ),
                            ],
                          ),
                        );
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Obx(() {
                  return BackdropBubble(
                    onTap: c.cart.isEmpty ? null : c.buy,
                    icon: const Icon(Icons.payment),
                    text: 'Buy',
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
