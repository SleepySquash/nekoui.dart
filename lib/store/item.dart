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
