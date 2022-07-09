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

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/domain/model/item.dart';
import '/ui/widget/conditional_backdrop.dart';
import '/ui/widget/escape_popper.dart';
import 'controller.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EscapePopper(
      child: GetBuilder(
        init: InventoryController(Get.find(), Get.find()),
        builder: (InventoryController c) {
          return Obx(() {
            return Stack(
              children: [
                AnimatedSwitcher(
                  duration: 300.milliseconds,
                  child: c.isDragging.value
                      ? Center(
                          child: SizedBox(
                            width: 400,
                            height: 400,
                            child: DragTarget<Item>(
                              onAccept: (i) {
                                c.use(i);
                                // c.lockDragging();
                                // Navigator.of(context).pop();
                              },
                              builder: ((context, candidates, rejected) {
                                return Center(
                                  child: ConditionalBackdropFilter(
                                    borderRadius: BorderRadius.circular(15),
                                    child: AnimatedScale(
                                      scale: candidates.isEmpty ? 1 : 1.1,
                                      duration: 150.milliseconds,
                                      curve: Curves.ease,
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color(0x60000000),
                                        ),
                                        child: const Icon(
                                          Icons.fastfood,
                                          size: 64,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                      : null,
                ),
                AnimatedSlide(
                  duration: 300.milliseconds,
                  curve: Curves.ease,
                  offset:
                      c.isDragging.value ? const Offset(-0.9, 0) : Offset.zero,
                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        title: const TabBar(
                          tabs: [
                            Tab(text: 'Food', icon: Icon(Icons.fastfood)),
                            Tab(text: 'Gifts', icon: Icon(Icons.favorite)),
                            Tab(text: 'Stuff', icon: Icon(Icons.add_box)),
                          ],
                        ),
                      ),
                      body: SafeArea(
                        child: TabBarView(
                          children: [
                            _buildItems(c, InventoryCategory.food),
                            _buildItems(c, InventoryCategory.gift),
                            _buildItems(c, InventoryCategory.stuff),
                          ],
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        },
      ),
    );
  }

  Widget _buildItems(InventoryController c, InventoryCategory category) {
    return Obx(() {
      Iterable<MapEntry<String, Item>> items = {};

      switch (category) {
        case InventoryCategory.food:
          items = c.items.entries.where((e) => e.value is Consumable);
          break;

        case InventoryCategory.gift:
          items = c.items.entries.where((e) => e.value is Giftable);
          break;

        case InventoryCategory.stuff:
          items = c.items.entries
              .where((e) => e.value is! Consumable && e.value is! Giftable);
          break;
      }

      if (items.isEmpty) {
        return Center(
          key: Key(category.name),
          child: const Text('Empty'),
        );
      }

      return Center(
        key: Key(category.name),
        child: Wrap(
          children: items.map(
            (e) {
              return Draggable<Item>(
                dragAnchorStrategy: pointerDragAnchorStrategy,
                onDragStarted: () => c.setDragging(true),
                onDragCompleted: () => c.setDragging(false),
                onDragEnd: (d) => c.setDragging(false),
                onDraggableCanceled: (d, v) => c.setDragging(false),
                rootOverlay: true,
                data: e.value,
                feedback: Transform.translate(
                  offset: const Offset(-20, -20),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image(
                      image: AssetImage(
                        e.value.asset,
                      ),
                    ),
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFDDDDDD),
                  ),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  child: Badge(
                    badgeContent: Text(
                      '${e.value.count}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: Image(
                      image: AssetImage(
                        e.value.asset,
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      );
    });
  }
}
