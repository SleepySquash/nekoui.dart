import '/domain/model/item.dart';
import '/util/obs/obs.dart';

abstract class AbstractItemRepository {
  RxObsMap<String, Item> get items;
  void add(Item item);
  void remove(Item item, [int? count]);
}
