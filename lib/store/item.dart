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

import 'dart:async';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model/item.dart';
import '/domain/repository/item.dart';
import '/provider/hive/item.dart';
import '/util/obs/obs.dart';

class ItemRepository extends DisposableInterface
    implements AbstractItemRepository {
  ItemRepository(this._itemHive);

  @override
  late final RxObsMap<String, Item> items;

  final ItemHiveProvider _itemHive;

  StreamIterator<BoxEvent>? _localSubscription;

  @override
  void onInit() {
    items = RxObsMap(
      Map.fromEntries(_itemHive.items.map((e) => MapEntry(e.id, e))),
    );

    _initLocalSubscription();

    // TODO: There should be an appropriate way to determine whether the [Box]
    //       was just created or not.
    if (_itemHive.isEmpty) {
      _itemHive.put(CakeItem(10));
      _itemHive.put(CupcakeItem(10));
      _itemHive.put(WaterBottleItem(10));
    }

    super.onInit();
  }

  @override
  void onClose() {
    _localSubscription?.cancel();
    super.onClose();
  }

  @override
  void add(Item item) async {
    Item? existing = _itemHive.get(item.id);
    if (existing != null) {
      existing.count.value += item.count.value;
      _itemHive.put(existing);
    } else {
      _itemHive.put(item);
    }
  }

  @override
  void remove(Item item, [int? count]) {
    Item? existing = _itemHive.get(item.id);
    if (existing != null) {
      existing.count.value -= count ?? existing.count.value;
      if (existing.count.value <= 0) {
        _itemHive.remove(item.id);
      } else {
        _itemHive.put(existing);
      }
    }
  }

  Future<void> _initLocalSubscription() async {
    _localSubscription = StreamIterator(_itemHive.boxEvents);
    while (await _localSubscription!.moveNext()) {
      BoxEvent e = _localSubscription!.current;
      if (e.deleted) {
        items.remove(e.key);
      } else {
        items[e.key] = e.value;
      }
    }
  }
}
