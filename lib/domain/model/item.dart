import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model_type_id.dart';

part 'item.g.dart';

abstract class Item extends HiveObject {
  Item(this.count);

  /// Unique [String] identifying this [Item].
  String get id;

  /// Path to the [Image] asset of this [Item].
  String get asset => 'assets/images/item/$id.png';

  /// Amount of this [Item].
  @HiveField(0)
  final RxInt count;
}

mixin Consumable on Item {}

/// [Item] that is edible by a [Neko].
mixin Eatable implements Consumable {
  /// Hunger being satisfied by consuming this [Item].
  int get hunger => 0;
}

/// [Item] that is drinkable by a [Neko].
mixin Drinkable implements Consumable {
  /// Thirst being satisfied by consuming this [Item].
  int get thirst => 0;
}

mixin WearableMixin on Item {}
mixin UseableMixin on Item {}

@HiveType(typeId: ModelTypeId.cupcakeItem)
class CupcakeItem extends Item with Eatable {
  CupcakeItem(super.count);

  @override
  String get id => 'cupcake';

  @override
  int get hunger => 10;
}

@HiveType(typeId: ModelTypeId.donutItem)
class DonutItem extends Item with Eatable {
  DonutItem(super.count);

  @override
  String get id => 'donut';

  @override
  int get hunger => 10;
}

@HiveType(typeId: ModelTypeId.cakeItem)
class CakeItem extends Item with Eatable {
  CakeItem(super.count);

  @override
  String get id => 'cake';

  @override
  int get hunger => 50;
}

@HiveType(typeId: ModelTypeId.icecreamItem)
class IcecreamItem extends Item with Eatable, Drinkable {
  IcecreamItem(super.count);

  @override
  String get id => 'icecream';

  @override
  int get hunger => 10;

  @override
  int get thirst => 1;
}

@HiveType(typeId: ModelTypeId.waterBottleItem)
class WaterBottleItem extends Item with Drinkable {
  WaterBottleItem(super.count);

  @override
  String get id => 'water_bottle';

  @override
  int get thirst => 40;
}
