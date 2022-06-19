import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class Item extends HiveObject {
  Item(int count) : count = RxInt(count);

  /// Unique [String] identifying this [Item].
  String get id;

  /// Path to the [Image] asset of this [Item].
  String get asset => 'assets/images/item/$id.png';

  /// Amount of this [Item].
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

class CupcakeItem extends Item with Eatable {
  CupcakeItem(super.count);

  @override
  String get id => 'cupcake';

  @override
  int get hunger => 10;
}

class DonutItem extends Item with Eatable {
  DonutItem(super.count);

  @override
  String get id => 'donut';

  @override
  int get hunger => 10;
}

class CakeItem extends Item with Eatable {
  CakeItem(super.count);

  @override
  String get id => 'cake';

  @override
  int get hunger => 50;
}

class IcecreamItem extends Item with Eatable, Drinkable {
  IcecreamItem(super.count);

  @override
  String get id => 'icecream';

  @override
  int get hunger => 10;

  @override
  int get thirst => 1;
}

class WaterBottleItem extends Item with Drinkable {
  WaterBottleItem(super.count);

  @override
  String get id => 'water_bottle';

  @override
  int get thirst => 40;
}
