import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model_type_id.dart';
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
    Hive.maybeRegisterAdapter(ItemAdapter());
    Hive.maybeRegisterAdapter(RxIntAdapter());
  }

  /// Puts the provided [Item] to the [Hive].
  Future<void> put(Item item) => putSafe(item.id, item);

  /// Returns the stored [Item] from the [Hive].
  Item? get(String id) => getSafe(id);

  /// Removes the stored [Item] from the [Hive].
  Future<void> remove(String id) => deleteSafe(id);
}

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final typeId = ModelTypeId.item;

  @override
  Item read(BinaryReader reader) {
    final runtimeType = reader.read() as String;
    final count = reader.read() as int;
    switch (runtimeType) {
      case 'CupcakeItem':
        return CupcakeItem(count);

      case 'DonutItem':
        return DonutItem(count);

      case 'CakeItem':
        return CakeItem(count);

      case 'IcecreamItem':
        return IcecreamItem(count);

      case 'WaterBottleItem':
        return WaterBottleItem(count);
    }

    throw UnimplementedError('Item $runtimeType is not found');
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer.write(obj.runtimeType.toString());
    writer.write(obj.count.value);
  }
}
