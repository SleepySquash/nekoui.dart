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

/// [Item] that is edible by a [Neko].
mixin EdibleMixin on Item {
  /// Hunger being satisfied by consuming this [Item].
  int get hunger => 0;
}

/// [Item] that is drinkable by a [Neko].
mixin DrinkableMixin on Item {
  /// Thirst being satisfied by consuming this [Item].
  int get thirst => 0;
}

mixin WearableMixin on Item {}
mixin UseableMixin on Item {}

@HiveType(typeId: ModelTypeId.cupcakeItem)
class CupcakeItem extends Item with EdibleMixin {
  CupcakeItem(super.count);

  @override
  String get id => 'cupcake';

  @override
  int get hunger => 10;
}

@HiveType(typeId: ModelTypeId.waterBottleItem)
class WaterBottleItem extends Item with DrinkableMixin {
  WaterBottleItem(super.count);

  @override
  String get id => 'water_bottle';

  @override
  int get thirst => 10;
}
