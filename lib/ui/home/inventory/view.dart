import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/domain/model/item.dart';
import '/ui/widget/conditional_backdrop.dart';
import '/ui/widget/escape_popper.dart';
import 'controller.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({Key? key}) : super(key: key);

  /// Displays a dialog with the provided [novel] above the current contents.
  static Future<T?> show<T extends Object?>({required BuildContext context}) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        final CapturedThemes themes = InheritedTheme.capture(
          from: context,
          to: Navigator.of(context, rootNavigator: true).context,
        );
        return themes.wrap(const InventoryView());
      },
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: 300.milliseconds,
    );
  }

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
