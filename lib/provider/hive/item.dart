import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model/item.dart';
import 'adapters.dart';
import 'base.dart';

/// [Hive] storage for the [Item]s.
class ItemHiveProvider extends HiveBaseProvider<Item> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch();

  @override
  String get boxName => 'item';

  /// Returns a list of [Item]s from the [Hive].
  Iterable<Item> get items => valuesSafe;

  @override
  void registerAdapters() {
    Hive.maybeRegisterAdapter(CakeItemAdapter());
    Hive.maybeRegisterAdapter(CupcakeItemAdapter());
    Hive.maybeRegisterAdapter(DonutItemAdapter());
    Hive.maybeRegisterAdapter(IcecreamItemAdapter());
    Hive.maybeRegisterAdapter(RxIntAdapter());
    Hive.maybeRegisterAdapter(WaterBottleItemAdapter());
  }

  /// Puts the provided [Item] to the [Hive].
  Future<void> put(Item item) => putSafe(item.id, item);

  /// Returns the stored [Item] from the [Hive].
  Item? get(String id) => getSafe(id);

  /// Removes the stored [Item] from the [Hive].
  Future<void> remove(String id) => deleteSafe(id);
}
