import '../disposable_service.dart';
import '/domain/model/item.dart';
import '/domain/repository/item.dart';
import '/util/obs/obs.dart';

/// Service responsible for [Item]s state management.
class ItemService extends DisposableService {
  ItemService(this._itemRepository);

  final AbstractItemRepository _itemRepository;

  RxObsMap<String, Item> get items => _itemRepository.items;

  void add(Item item) => _itemRepository.add(item);

  /// Removes the provided [item] in the specified [count] from the [items].
  ///
  /// Fully removes the [item], if [count] is `null`.
  void remove(Item item, [int? count]) => _itemRepository.remove(item, count);
}
